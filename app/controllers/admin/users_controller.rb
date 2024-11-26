class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.includes(:posts).all
  end

  def show
    @user = User.includes(posts: [:favorites, :post_comments]).find(params[:id])
  end

  def user_favorite
    @user = User.includes(posts: [:favorites, :post_comments]).find(params[:user_id])
  end

  def rooms
    @user = User.find(params[:id]) # params[:id]で指定されたユーザーを取得
    @rooms = Room.joins(:entries).where(entries: { user_id: @user.id }).distinct
  end
end
