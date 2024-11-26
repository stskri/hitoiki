class Admin::RoomsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @rooms = Room.includes(:messages, :entries) # 必要に応じて関連付けをプリロード
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages.includes(:user)
  end

  def destroy
    room = Room.find(params[:id])
    if room.destroy
      redirect_to rooms_path, notice: "削除しました"
    else
      redirect_to rooms_path, alert: "ルームの削除に失敗しました"
    end
  end
end
