class DraftInquiry < ApplicationRecord
  belongs_to :user

  enum genre: {account: 0, feature_request: 1, bug_report: 2, other: 3}
end
