# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :user_suspension?, only: [:create]

  def after_sign_in_path_for(resource)
    posts_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  def user_suspension?
    @user = User.find_by(email: params[:user][:email])

    if @user
      if @user.valid_password?(params[:user][:password]) && @user.active_for_authentication?
        # 正常なログイン処理（ユーザーが存在し、パスワードも正しく、アカウントが有効な場合）
      elsif @user.valid_password?(params[:user][:password]) && !@user.active_for_authentication?
        # アカウントが無効（:is_activeがfalse）でパスワードが正しい場合
        flash[:alert] = "アカウントは管理者によって停止されています"
        redirect_to root_path and return
      else
        # パスワードが間違っている場合
        flash[:alert] = "パスワードが間違っています"
        redirect_to root_path and return
      end
    else
      # メールアドレスが見つからない場合
      flash[:alert] = "該当するユーザーが見つかりません"
      redirect_to root_path and return
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
