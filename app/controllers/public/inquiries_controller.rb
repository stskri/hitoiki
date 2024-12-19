class Public::InquiriesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:show, :destroy]

  def new
    @inquiry = Inquiry.new
    @genres = Inquiry.genres
  end

  def index
    @inquiries = current_user.inquiries.order(created_at: :desc).page(params[:page]).per(25)
  end

  def show
    @inquiry = Inquiry.find(params[:id])
  end

  def create
    inquiry = Inquiry.new(inquiry_params)
    inquiry.genre = params[:inquiry][:genre]
    inquiry.user_id = current_user.id
    inquiry.is_active = true
    if inquiry.save
      redirect_to inquiries_path, notice: "お問い合わせを送信しました"
    else
      if inquiry.body.blank? and inquiry.genre.blank?
        redirect_to request.referer, alert: "ジャンルを選択し、本文を入力してください"
      elsif inquiry.body.blank?
        redirect_to request.referer, alert: "本文を入力して下さい"
      elsif inquiry.genre.blank?
        redirect_to request.referer, alert: "ジャンルを選択して下さい"
      else
        redirect_to request.referer, alert: "お問い合わせの送信に失敗しました"
      end
    end
  end

  def destroy
    inquiry = Inquiry.find(params[:id])
    if inquiry.destroy
      redirect_to inquiries_path, notice: "お問い合わせを削除しました"
    else
      redirect_to request.referer, alert: "お問い合わせの削除に失敗しました"
    end
  end


  private

  def inquiry_params
    params.require(:inquiry).permit(:body)
  end

  def ensure_correct_user
    if Inquiry.exists?(params[:id])
      inquiry = Inquiry.find(params[:id])
      unless inquiry.user == current_user
        redirect_to inquiries_path, alert: '無効なアクセスです'
      end
    else
      redirect_to inquiries_path, alert: "無効なアクセスです"
    end
  end
end
