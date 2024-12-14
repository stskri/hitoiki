class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.includes(:posts).all
  end

  def show
    @user = User.find(params[:id])
    @user_posts = @user.posts.includes(:favorites, :post_comments, :post_emotions, :user).page(params[:page]).per(25)
  end

  def user_favorite
    @user = User.includes(posts: [:favorites, :post_comments]).find(params[:user_id])
  end

  def rooms
    @user = User.find(params[:id]) # params[:id]で指定されたユーザーを取得
    @rooms = Room.joins(:entries).where(entries: { user_id: @user.id }).distinct
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user)
      flash[:notice] = "ユーザー情報を更新しました"
    else
      redirect_to admin_user_path(@user)
      flash[:alert] = "ユーザー情報の更新に失敗しました"
    end
  end


  private
  def user_params
    params.require(:user).permit(:is_active)
  end
end
