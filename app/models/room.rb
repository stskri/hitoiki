class Room < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :users, through: :entries

  validates :user_1_id, presence: true
  validates :user_2_id, presence: true
end
