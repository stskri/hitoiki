class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, dependent: :destroy

  validates :comment, length: { maximum: 31 }, presence: true

end
