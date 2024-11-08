class Room < ApplicationRecord
  belongs_to :user
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
end
