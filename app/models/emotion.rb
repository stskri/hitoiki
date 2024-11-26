class Emotion < ApplicationRecord
  has_many :post_emotions
  has_many :posts, through: :post_emotions

  validates :name, presence: true, uniqueness: true
  validates :color, presence: true, uniqueness: true
end
