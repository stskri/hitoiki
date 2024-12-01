class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    @room = Room.new
    current_user.follow(@user)
    @user.create_notification_follow(current_user)
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
  end

  def followings
    @user = User.find(params[:user_id])
    @followings = @user.followings.page(params[:page]).per(1)
  end

  def followers
    @user = User.find(params[:user_id])
    @followers = @user.followers.page(params[:page]).per(25)
  end
end
