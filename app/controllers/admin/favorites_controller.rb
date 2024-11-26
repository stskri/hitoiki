class Admin::FavoritesController < ApplicationController
  before_action :authenticate_admin!
  def favorite_users
    @post = Post.find(params[:post_id])
    @users = @post.favorites.map(&:user)
  end
end
