class Public::RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    # current_userの参加しているルームIDを取得
    current_user_rooms_id = Entry.where(user_id: current_user.id).pluck(:room_id)
    # ルーム情報を新着順で取得
    @rooms = Room.joins(:messages)
                .where(id: current_user_rooms_id)
                .select('rooms.*, MAX(messages.created_at) as latest_message_time')
                .group('rooms.id')
                .order('latest_message_time DESC')
                .page(params[:page]).per(15)
    # 未読通知があるルームIDを取得
    @unread_rooms = Notification.where(visited_id: current_user.id, checked: false, room_id: current_user_rooms_id).pluck(:room_id)
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
    @message = Message.new
    @messages = @room.messages.includes(:user)
    notifications = current_user.passive_notifications.where(checked: false, room_id: @room.id)
    notifications.update(checked: true)
  end

  # もしdestroyを実装する場合
  # def destroy
  #   room = Room.find(params[:id])
  #   if room.users.include(current_user)
  #     if room.destroy
  #       redirect_to rooms_path, notice: "削除しました"
  #     else
  #       redirect_to rooms_path, alert: "ルームの削除に失敗しました"
  #     end
  #   else
  #     redirect_to rooms_path, alert: "無効なアクセスです"
  #   end
  # end
end
