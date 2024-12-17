class Post < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :post_emotions, dependent: :destroy
  has_many :emotions, through: :post_emotions
  has_many :post_comments, dependent: :destroy
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

  def update_notification_is_active(new_value, current_user)
    if new_value == false
      # 自分以外の関連する通知のis_activeをfalseにする
      notifications.where(post_id: id).where.not(visited_id: current_user.id).update_all(is_active: false)
    else
      # 再び公開された場合、自分以外の関連する通知のis_activeをtrueにする
      notifications.where(post_id: id).where.not(visited_id: current_user.id).update_all(is_active: true)
    end
    update(is_public: new_value)
  end
end
