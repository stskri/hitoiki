class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @posts = Post.includes(:favorites, :post_comments, :post_emotions, :user).page(params[:page]).per(25)
  end

  def show
    @post = Post.find(params[:id])
    @post_comments = PostComment.where(post_id: @post.id)
  end

  def destroy
    post = Post.find(params[:id])
    if post.destroy
      redirect_to posts_path, notice: '投稿を削除しました'
    else
      redirect_to post_path(post.id), alert: '投稿の削除に失敗しました'
    end
  end
end
