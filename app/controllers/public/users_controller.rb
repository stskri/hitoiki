class Public::UsersController < ApplicationController
  def show
  end

  def my_page
    @user = current_user
    @post = Post.where(user: current_user)
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

  private
  def user_params
    params.require(:user).permit(:name, :introduction)
  end
end
