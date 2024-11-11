class Inquiry < ApplicationRecord
  belongs_to :user

  validates :body, presence: true
  validates :genre, presence: true
end
