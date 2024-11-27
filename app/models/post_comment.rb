class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, dependent: :destroy

  validates :comment, length: { maximum: 31 }, presence: true


  def create_notification_post_comment(current_user, post_comment_id)
    # 通知先ユーザーのIDをユニークに管理するためのセット
    notified_user_ids = Set.new

    # 既存のコメントユーザーに通知（重複を除く、自分以外）
    already_post_comment_user_ids = PostComment.where(post_id: self.post_id)
                                              .where.not(user_id: current_user.id)
                                              .pluck(:user_id)
                                              .uniq
    already_post_comment_user_ids.each do |user_id|
      notified_user_ids.add(user_id)
      save_notification_post_comment(current_user, post_comment_id, user_id)
    end

    # 投稿主に通知（既存コメントユーザーとして通知済みでなければ）
    post_owner_id = self.post.user_id
    unless post_owner_id == current_user.id || notified_user_ids.include?(post_owner_id)
      save_notification_post_comment(current_user, post_comment_id, post_owner_id)
    end
  end

  private

  def save_notification_post_comment(current_user, post_comment_id, visited_id)
    notification = current_user.active_notifications.new(
      post_id: self.post_id,
      post_comment_id: post_comment_id,
      visited_id: visited_id,
      action: "post_comment"
    )
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end
end
