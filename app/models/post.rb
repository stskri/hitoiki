class Post < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :post_emotion, dependent: :destroy
  has_many :post_comment, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :body, length: { maximum: 31 }, presence: true

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(content, method)
    if method == 'perfect'
      Post.where(body: content)
    elsif method == 'forward'
      Post.where('body LIKE?', content + '%')
    elsif method == 'backword'
      Post.where('body LIKE?', '%' + content)
    else
      Post.where('body LIKE?', '%' + content + '%')
    end
  end

  def create_notification_favorite(current_user)
    # Postが既に該当ユーザーからいいねされているか
    already_favorite = Notification.where(visitor_id: current_user.id, visited_id: user_id, post_id: id, action: "favorite")
    # いいねされていない場合
    if already_favorite.blank?
      # 通知を作成
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: "favorite"
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

  def create_notification_post_comment(current_user, post_comment_id)
    # 既に自分以外のコメントがついているか
    already_post_comment_user_ids = PostComment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    # コメントがあるなら、投稿ユーザー全員に通知を送る
    already_post_comment_user_ids.each do |user_id|
      save_notification_post_comment(current_user, post_comment_id, user_id['user_id'])
    end
    # コメントがない場合、投稿者のみに通知を送る
    save_notification_post_comment(current_user, post_comment_id, user_id['user_id'])
  end

  def save_notification_post_comment(current_user, post_comment_id, visited_id)
    # コメントに対する通知を作成
    notification = current_user.active_notifications.new(
      post_id: id,
      post_comment_id: post_comment_id,
      visited_id: visited_id,
      action: "post_comment"
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
