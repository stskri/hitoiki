class Emotion < ApplicationRecord
  has_many :post_emotions, dependent: :destroy
end
