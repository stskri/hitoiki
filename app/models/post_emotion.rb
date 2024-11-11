class PostEmotion < ApplicationRecord
  belongs_to :post
  belongs_to :emotion
  validates :emotion_name, presence: true
  validates :emotion_color, presence: true
end
