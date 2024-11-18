class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:update]
  before_action :guide_to_my_page, only: [:show]

  def show
    @user = User.find(params[:id])
    @favorited_posts = @user.favorited_posts
  end

  def my_page
    @user = current_user
    @favorited_posts = @user.favorited_posts
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

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to books_path, alert: '無効なアクセスです'
    end
  end

  # users/:current_user.idにアクセスした場合、my_pageへ
  def guide_to_my_page
    if User.find(params[:id]) == current_user
      redirect_to my_page_path
    end
  end
end
