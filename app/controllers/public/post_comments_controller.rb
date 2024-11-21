class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:destroy]

  def create
    post = Post.find(params[:post_id])
    comment = PostComment.new(post_comment_params)
    comment.user_id = current_user.id
    comment.post_id = post.id
    if comment.save
      post.create_notification_post_comment(current_user, comment.id)
      redirect_to request.referer, notice: 'コメントを送信しました'
    else
      redirect_to request.referer, alert: 'コメントの送信に失敗しました'
    end
  end



  def destroy
    comment = PostComment.find(params[:id])
    if comment.destroy
      redirect_to request.referer, notice: 'コメントを削除しました'
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
