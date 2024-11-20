class Public::MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.find(params[:id])
    unless @room.users.include?(current_user)
      redirect_to rooms_path, alert: "メッセージの送信に失敗しました" and return
    end
    @message = Message.new(message_params)
    @message.user_id = current_user.id
    @message.room_id = @room.id
    if @message.save
      redirect_to request.referer, notice: 'メッセージを送信しました'
    else
      redirect_to request.referer, alert: 'メッセージの送信に失敗しました'
    end
  end

  def destroy
    room = Room.find(params[:id])

    message = Message.find(params[:id])
    if message.user == current_user
      if message.destroy
        redirect_to request.referer, notice: 'メッセージを削除しました'
      else
        redirect_to request.referer, alert: 'メッセージの削除に失敗しました'
      end
    else
      redirect_to request.referer, alert: "無効なアクセスです"
    end
  end


  private
  def message_params
    params.require(:message).permit(:message)
  end
end
