class Post < ApplicationRecord
  belongs_to :user
  belongs_to :favorite
  has_many :post_emotion, dependent: :destroy
  has_many :post_comment, dependent: :destroy
end
