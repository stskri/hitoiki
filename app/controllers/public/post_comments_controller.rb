class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:destroy]

  def post_comment_users
    @post = Post.includes(post_comments: :user).find(params[:post_id])
    @users = @post.post_comments.map(&:user).uniq
  end

  def create
    post = Post.find(params[:post_id])
    @post_comments = PostComment.where(post_id: post.id)
    @post_comment = current_user.post_comments.new(post_comment_params.merge(post_id: params[:post_id]))
    if @post_comment.save
      @post_comment.create_notification_post_comment(current_user, @post_comment.id)
    else
      redirect_to request.referer, alert: 'コメントの送信に失敗しました'
    end
  end

  def destroy
    @post_comment = PostComment.find(params[:id])
    if @post_comment.destroy
    else
      redirect_to request.referer, alert: 'コメントの削除に失敗しました'
    end
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

  def ensure_correct_user
    @comment = PostComment.find(params[:id])
    unless @comment.user == current_user
      redirect_to root_path, alert: '無効なアクセスです'
    end
  end
end
