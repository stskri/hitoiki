class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!

  def post_comment_users
    @post = Post.includes(post_comments: :user).find(params[:post_id])
    @users = @post.post_comments.map(&:user).uniq
  end

  def destroy
    post = Post.find(params[:post_id])
    comment = PostComment.find(params[:id])
    if comment.destroy
      redirect_to admin_post_path(post), notice: 'コメントを削除しました'
    else
      redirect_to request.referer, alert: 'コメントの削除に失敗しました'
    end
  end
end
