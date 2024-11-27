class Admin::RoomsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @rooms = Room.includes(:messages, :entries) # 必要に応じて関連付けをプリロード
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages.includes(:user)
  end
end
