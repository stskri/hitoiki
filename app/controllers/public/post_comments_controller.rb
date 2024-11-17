class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:create, :destroy]

  def create
    post = Post.find(params[:post_id])
    comment = PostComment.new(post_comment_params)
    comment.user_id = current_user.id
    comment.post_id = post.id
    if comment.save
      redirect_to request.referer, notice: 'コメントを送信しました'
    else
      redirect_to request.referer, alert: 'コメントの送信に失敗しました'
    end
  end



  def destroy
    comment = PostComment.find(params[:id])
    if comment.destroy
      edirect_to request.referer, notice: 'コメントを削除しました'
    else
      edirect_to request.referer, alert: 'コメントの削除に失敗しました'
    end
  end

  private
  def post_comment_param
    params.require(:post_comment).permit(:comment)
  end

  def ensure_correct_user
    @comment = PostComment.find(params[:id])
    unless @comment.user == current_user
      redirect_to books_path, alert: '無効なアクセスです'
    end
  end
end
