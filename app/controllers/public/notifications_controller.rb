class Public::NotificationsController < ApplicationController
  def mark_as_read
    notifications = current_user.passive_notifications.where(checked: false)
    notifications.update_all(checked: true)
  end
end