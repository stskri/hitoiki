class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.includes(:posts).all
  end

  def show
    @user = User.includes(posts: [:favorites, :post_comments]).find(params[:id])
  end

end
