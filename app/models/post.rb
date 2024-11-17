class Post < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :post_emotion, dependent: :destroy
  has_many :post_comment, dependent: :destroy

  validates :body, length: { maximum: 31 }, presence: true

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(content, method)
    if method == 'perfect'
      Post.where(name: content)
    elsif method == 'forward'
      Post.where('name LIKE?', content + '%')
    elsif method == 'backword'
      Post.where('name LIKE?', '%' + content)
    else
      Post.where('name LIKE?', '%' + content + '%')
    end
  end
end
