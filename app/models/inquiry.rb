class Inquiry < ApplicationRecord
  belongs_to :user

  validates :body, presence: true
  validates :genre, presence: true

  enum genre: {account: 0, feature_request: 1, bug_report: 2, other: 3}

  validates :body, length: { maximum: 1000 }, presence: true
  validates :genre, presence: true
end
