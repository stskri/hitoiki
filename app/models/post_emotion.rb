class PostEmotion < ApplicationRecord
  belongs_to :post
  belongs_to :emotion
end
