class Public::RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rooms = current_user.rooms
  end

  def create
    # params[:room][:user_id]はusers#showのform_withで取得している相手のuser_id
    target_user_id = params[:room][:user_id]
    # current_userの持つメッセージルームのidを配列で取得
    current_user_rooms = Entry.where(user_id: current_user.id).pluck(:room_id)
    # 相手の持つメッセージルームのidを配列で取得
    target_user_rooms = Entry.where(user_id: target_user_id).pluck(:room_id)
    # 重複しているメッセージルームのIDをexisting_room_idに代入
    existing_room_id = (current_user_rooms & target_user_rooms).first
    if existing_room_id
      # 重複しているメッセージルームがある場合は、該当するメッセージルームにリダイレクト
      redirect_to room_path(existing_room_id)
    else
      # 重複しているメッセージルームがない場合、新たにメッセージルームをcreate
      @room = Room.create
      Entry.create(user_id: current_user.id, room_id: @room.id)
      Entry.create(user_id: params[:room][:user_id], room_id: @room.id)
      redirect_to room_path(@room), notice: "メッセージルームが作成されました"
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
