class Admin::MessagesController < ApplicationController
  before_action :authenticate_admin!
  def destroy
    @room = Room.find(params[:room_id])
    @messages = @room.messages.includes(:user)
    @message = Message.find(params[:id])
    if @message.destroy
      # flash[:notice] = 'メッセージが削除されました'
    else
      redirect_to request.referer, alert: 'メッセージの削除に失敗しました'
    end
  end
end
