class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, dependent: :destroy

  validates :comment, length: { maximum: 31 }, presence: true


  def create_notification_post_comment(current_user, post_comment_id)
    # 既に自分以外のコメントがついているかを確認
    already_post_comment_user_ids = PostComment.select(:user_id).where(post_id: self.post_id).where.not(user_id: current_user.id).distinct

    # コメントがある場合、コメントしたユーザー全員に通知を送る
    already_post_comment_user_ids.each do |user|
      save_notification_post_comment(current_user, post_comment_id, user.user_id)
    end
    # 投稿者への通知を追加
    save_notification_post_comment(current_user, post_comment_id, self.post.user_id)
  end

  def save_notification_post_comment(current_user, post_comment_id, visited_id)
    # コメントに対する通知を作成
    notification = current_user.active_notifications.new(
      post_id: self.post_id,
      post_comment_id: post_comment_id,
      visited_id: visited_id,
      action: "post_comment"
    )

    # 通知の送り元と送信先が同一ユーザーの場合、確認済みにする
    notification.checked = true if notification.visitor_id == notification.visited_id

    # 通知が有効な場合に保存
    notification.save if notification.valid?
  end
end
