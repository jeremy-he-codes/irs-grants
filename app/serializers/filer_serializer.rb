class FilerSerializer < BaseSerializer
  attributes :id, :name, :ein
  has_one :address
end
