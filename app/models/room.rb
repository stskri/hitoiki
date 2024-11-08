class Room < ApplicationRecord
  belongs_to :user
  has_many :entry, dependent: :destroy
  has_many :message, dependent: :destroy
end
