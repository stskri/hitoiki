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
end
