class Post < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :post_emotion, dependent: :destroy
  has_many :post_comment, dependent: :destroy

  validates :body, length: { maximum: 31 }, presence: true

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
