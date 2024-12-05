class Admin::InquiriesController < ApplicationController
  before_action :authenticate_admin!

  def unanswered_inquiries
    @inquiries = Inquiry.includes(:user)
                        .where(is_active: true)
                        .page(params[:page]).per(25)
  end

  def mark_as_resolved
    @inquiry = Inquiry.find(params[:id])
    if @inquiry.is_active == true
      if @inquiry.update(is_active: false)
      else
        redirect_to admin_inquiries_path, alert: "確認済みにする処理に失敗しました"
      end
    else
      if @inquiry.update(is_active: true)
      else
        redirect_to admin_inquiries_path, alert: "確認済みにする処理に失敗しました"
      end
    end
  end

  def index
    @inquiries = Inquiry.includes(:user).order(created_at: :desc).page(params[:page]).per(25)
  end

  def show
    @inquiry = Inquiry.find(params[:id])
  end

  def destroy
    inquiry = Inquiry.find(params[:id])
    if inquiry.destroy
      redirect_to admin_inquiries_path, notice: "お問い合わせを削除しました"
    else
      redirect_to request.referer, alert: "お問い合わせの削除に失敗しました"
    end
  end

  def update
  inquiry = Inquiry.find(params[:id])
    if inquiry.update(inquiry_params)
      redirect_to admin_inquiry_path(inquiry)
      flash[:notice] = "お問い合わせ情報を更新しました"
    else
      redirect_to admin_inquiry_path(inquiry)
      flash[:alert] = "お問い合わせ情報の更新に失敗しました"
    end
  end


  private
  def inquiry_params
    params.require(:inquiry).permit(:is_active)
  end
end
