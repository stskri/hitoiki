class Emotion < ApplicationRecord
  has_many :post_emotion, dependent: :destroy
end
