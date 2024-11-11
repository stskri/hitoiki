class Post < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :post_emotion, dependent: :destroy
  has_many :post_comment, dependent: :destroy

  validates :body, presence: true
end
