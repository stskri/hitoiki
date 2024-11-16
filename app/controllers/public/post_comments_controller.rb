class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!

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
    if comment.user == current.user
      if comment.destroy
        edirect_to request.referer, notice: 'コメントを削除しました'
      else
        edirect_to request.referer, alert: 'コメントの削除に失敗しました'
      end
    else
      redirect_to request.referer, alert: '削除権限がありません'
    end
  end


  private
  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
