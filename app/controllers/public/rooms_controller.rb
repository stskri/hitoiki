class Public::RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rooms = current_user.rooms
  end

  def create
    existing_room = Room.find_by(user_1_id: params[:room][:user_1_id], user_2_id: params[:room][:user_2_id]) ||
                    Room.find_by(user_1_id: params[:room][:user_2_id], user_2_id: params[:room][:user_1_id])
    if existing_room != nil
      redirect_to room_path(existing_room)
    else
      @room = Room.new(user_1_id: params[:room][:user_1_id], user_2_id: params[:room][:user_2_id])
      if @room.save
        Entry.create(user_id: @room.user_1_id, room_id: @room.id)
        Entry.create(user_id: @room.user_2_id, room_id: @room.id)
        redirect_to room_path(@room), notice: "メッセージルームが作成されました"
      else
        redirect_to request.referer, alert: "メッセージルームの作成に失敗しました"
      end
    end
  end

  def show
    @room = Room.find(params[:id])
    unless @room.users.include?(current_user)
      redirect_to rooms_path, alert: "無効なアクセスです" and return
    end
    @messages = @room.messages
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
