class Filing < ApplicationRecord
  belongs_to :filer, class_name: 'Organization', foreign_key: :filer_id
  has_many :awards

  validates_presence_of :tax_year
  validates :tax_year, uniqueness: { scope: :filer_id }
end
