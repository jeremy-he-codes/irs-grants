class Organization < ApplicationRecord
  has_many :filings, inverse_of: :filer, :foreign_key => :filer_id
  has_many :awards, inverse_of: :recipient, :foreign_key => :recipient_id
  has_one :address, as: :addressable

  validates_presence_of :name
  validates_uniqueness_of :ein, allow_nil: true

  scope :filer, -> { where(is_filer: true) }
  scope :recipient, -> { where(is_recipient: true) }
end
