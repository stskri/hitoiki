class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  has_one_attached :image
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :inquiries, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_one :draft_inquiry, dependent: :destroy
  has_one :draft_post, dependent: :destroy

  # my_pageにいいねした投稿を一覧表示させるため、favoritesを通じてpostを取得する
  has_many :favorited_posts, through: :favorites, source: :post

  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed

  # 相手からの通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  # 自分からの通知
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 }
  validates :introduction, length: { maximum: 50 }

  # 指定したカラムのメソッドがtrueの場合、trueを返す
  def active_for_authentication?
    super && self.is_active == true
  end

  # ゲストログインのためのメソッド
  GUEST_USER_EMAIL_1 = "guest1@example.com"
  GUEST_USER_EMAIL_2 = "guest2@example.com"
  def self.guest1
    find_or_create_by!(email: GUEST_USER_EMAIL_1) do |user|
      file_path = Rails.root.join('app/assets/images/blue.png')
      user.image.attach(io: File.open(file_path), filename: 'blue.png', content_type: 'image/png')
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー１"
    end
  end

  def self.guest2
    find_or_create_by!(email: GUEST_USER_EMAIL_2) do |user|
      file_path = Rails.root.join('app/assets/images/green.png')
      user.image.attach(io: File.open(file_path), filename: 'green.png', content_type: 'image/png')
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー２"
    end
  end

  # ゲストユーザーか確認するためのメソッド
  def guest_user?
    email == GUEST_USER_EMAIL_1 || email == GUEST_USER_EMAIL_2
  end

  # ユーザー画像のサイズを調整
  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_fill: [width, height]).processed
  end

  def follow(user)
    relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  # ユーザー検索
  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE?', content + '%')
    elsif method == 'backword'
      User.where('name LIKE?', '%' + content)
    else
      User.where('name LIKE?', '%' + content + '%')
    end
  end

  def create_notification_follow(current_user)
    # 既に自分をフォローしていたか
    already_follow = Notification.where(visitor_id: current_user.id, visited_id: id, action: "follow")
    # フォローされていない場合
    if already_follow.blank?
      # 通知を作成
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: "follow"
      )
      # notificationがバリデーションを満たしている場合、notificationをsave
      notification.save if notification.valid?
    end
  end
end