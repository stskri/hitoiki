class Public::InquiriesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:show, :destroy]

  def new
    @inquiry = Inquiry.new
    @genres = Inquiry.genres
  end

  def index
    @inquiries = current_user.inquiries
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
      redirect_to request.referer, alert: "お問い合わせの送信に失敗しました"
    end
  end

  def destroy
  end


  private

  def inquiry_params
    params.require(:inquiry).permit(:body)
  end

  def ensure_correct_user
    @inquiry = Inquiry.find(params[:id])
    unless @inquiry.user == current_user
      redirect_to root_path, alert: '無効なアクセスです'
    end
  end
end
