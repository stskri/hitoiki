class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:create, :destroy]

  def create
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: @post.id)
    favorite.save
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post.id)
    favorite.destroy
  end

  def ensure_correct_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to books_path, alert: '無効なアクセスです'
    end
  end
end
