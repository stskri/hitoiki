class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
    redirect_to request.referer, notice: 'フォローしました'
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    redirect_to request.referer, notice: 'フォローを解除しました'
  end

  def followings
    @user = User.find(params[:user_id])
    @followings = user.followings
  end

  def followers
    @user = User.find(params[:user_id])
    @followers = user.followers
  end
end
