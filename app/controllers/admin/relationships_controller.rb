class Admin::RelationshipsController < ApplicationController
  def followings
    @user = User.find(params[:user_id])
    @followings = @user.followings
  end

  def followers
    @user = User.find(params[:user_id])
    @followers = @user.followers
  end
end
