class Admin::RoomsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @rooms = Room.includes(:messages, :entries) # 必要に応じて関連付けをプリロード
  end

  def show
    if Room.exists?(params[:id]) # 存在するかどうかをまず確認
      @room = Room.find(params[:id])
      @messages = @room.messages.includes(:user)
    else
      redirect_to admin_rooms_path, alert: "メッセージルームが存在しません"
    end
  end
end
