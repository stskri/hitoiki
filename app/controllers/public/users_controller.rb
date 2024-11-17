class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.find(params[:id])
    @favorited_posts = @user.favorited_posts
  end

  def my_page
    @user = current_user
    @favorited_posts = current_user.favorited_posts
  end

  def edit
    @user = current_user
  end

  def update
    user = current_user
    if user.update(user_params)
      redirect_to my_page_path, notice: '変更を保存しました'
    else
      redirect_to request.referer, alert: '変更の保存に失敗しました'
    end
  end

  # 新規登録画面で登録失敗した際にURLが/usersとなり、リロードするとRouting Errorが表示されてしまうため、routesにget 'users' => 'users#dummy'を記述している
  def dummy
    redirect_to new_user_registration_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :image)
  end
end
