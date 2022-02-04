class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  validates_presence_of :country, :state, :city, :zip_code, :address_line1
end
