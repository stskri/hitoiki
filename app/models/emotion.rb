class Emotion < ApplicationRecord
  has_many :post_emotions, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :color, presence: true, uniqueness: true
end
