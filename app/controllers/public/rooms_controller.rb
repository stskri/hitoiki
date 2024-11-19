class Public::RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rooms = current_user.rooms
  end

  def create
    @room = Room.create(user_id: current_user.id)
    Entry.create(user_id: current_user.id, room_id: @room.id)
    Entry.create(user_id: params[:id], room_id: @room.id)
    redirect_to room_path(@room)
  end

  def show
    @room = Room.find(params[:id])
    unless @rooms.users.include?(current_user)
      redirect_to rooms_path, alert: "無効なアクセスです" and return
    end
    @messages = @rooms.messages
    @message = Message.new
  end

  def destroy
    room = Room.find(params[:id])
    if room.users.include(current_user)
      if room.destroy
        redirect_to rooms_path, notice: "削除しました"
      else
        redirect_to rooms_path, alert: "ルームの削除に失敗しました"
      end
    else
      redirect_to rooms_path, alert: "無効なアクセスです"
    end
  end
end
