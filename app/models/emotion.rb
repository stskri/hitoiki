class Emotion < ApplicationRecord
  has_many :post_emotions, dependent: :destroy

  validates :name, presence: true
  validates :color, presence: true
end
