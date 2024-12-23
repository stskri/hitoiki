class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.includes(:posts).all
  end

  def show
    if User.exists?(params[:id]) # 存在するかどうかをまず確認
      @user = User.find(params[:id])
      @user_posts = @user.posts.includes(:favorites, :post_comments, :post_emotions, :user).page(params[:page]).per(25)
    else
      redirect_to admin_users_path, alert: "ユーザーが存在しません"
    end
  end

  def user_favorite
    @user = User.find(params[:user_id])
    @favorited_posts = @user.favorited_posts.includes(:favorites, :post_comments, :post_emotions, :user).page(params[:page]).per(25)
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
