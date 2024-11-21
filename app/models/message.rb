class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many :notifications, dependent: :destroy

  validates :message, presence: true, length: { maximum: 31 }

  # メッセージの通知を作成するメソッド
  def create_notification_message(current_user)
    # ルームにエントリーしている自分以外のuserを抽出
    room.entries.where.not(user_id: current_user.id).each do |entry|
      # 通知を作成
      notification = current_user.active_notifications.new(
        message_id: id,
        visited_id: entry.user_id,
        action: "message"
      )
      # 通知の送り元と送信先が同一ユーザーの場合
      if notification.visitor_id == notification.visited_id
        # 確認済みにする
        notification.checked = true
      end
      # notificationがバリデーションを満たしている場合、notificationをsave
      notification.save if notification.valid?
    end
  end
end
