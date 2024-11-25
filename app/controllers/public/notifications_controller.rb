class Public::NotificationsController < ApplicationController
  def mark_as_read
    notifications = current_user.passive_notifications.where(checked: false)
    notifications.update_all(checked: true)
  end

  def more_notifications
    @notifications = current_user.passive_notifications
                                  .where.not(visitor_id: current_user.id)
                                  .includes(:visitor, :post, :post_comment, :message)
                                  .order(created_at: :desc)
                                  .page(params[:page]).per(25) # 追加で25件を取得
  end
end