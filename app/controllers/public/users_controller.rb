class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :guide_to_my_page, only: [:show]
  before_action :ensure_guest_user, only: [:edit]

  def show
    @user = User.find(params[:id])
    @user_posts = @user.posts.includes(:favorites, :post_comments, :post_emotions, :user).page(params[:page]).per(2)
    @favorited_posts = @user.favorited_posts
    @room = Room.new
    notifications = current_user.passive_notifications.where(checked: false, action: "follow", visitor_id: @user.id)
    notifications.update(checked: true)
  end

  def my_page
    @user = current_user
    @my_posts = current_user.posts.includes(:favorites, :post_comments, :post_emotions, :user).page(params[:page]).per(25)
  end

  def my_favorite
    @favorited_posts = current_user.favorited_posts.includes(:favorites, :post_comments, :post_emotions, :user).page(params[:page]).per(25)
  end

  def edit
    @user = User.find(params[:id])
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
      redirect_to root_path, alert: '無効なアクセスです'
    end
  end

  # users/:current_user.idにアクセスした場合、my_pageへ
  def guide_to_my_page
    if User.find(params[:id]) == current_user
      redirect_to my_page_path
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user) , alert: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end
end
