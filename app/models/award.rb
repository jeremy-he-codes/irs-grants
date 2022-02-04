class Award < ApplicationRecord
  belongs_to :filing
  belongs_to :recipient, class_name: 'Organization', foreign_key: :recipient_id

  validates_presence_of :amount
end
