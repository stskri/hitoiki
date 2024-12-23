class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!

  def favorite_users
    @post = Post.find(params[:post_id])
    @users = @post.favorites.map(&:user)
  end

  def create
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: @post.id)
    favorite.save
    @post.create_notification_favorite(current_user)
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post.id)
    favorite.destroy
  end
end
