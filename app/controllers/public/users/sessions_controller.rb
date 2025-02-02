module Public
  class Users::SessionsController < Devise::SessionsController
    def guest1_sign_in
      user = User.guest1
      sign_in user
      redirect_to root_path, notice: 'ゲストユーザー１としてログインしました。'
    end

    def guest2_sign_in
      user = User.guest2
      sign_in user
      redirect_to root_path, notice: 'ゲストユーザー２としてログインしました。'
    end
  end
end