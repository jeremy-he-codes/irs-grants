class RecipientSerializer < BaseSerializer
  attributes :id, :name, :ein
  attribute :amount, if: :include_sum?
  has_one :address

  def include_sum?
    instance_options[:include_sum]
  end

  def amount
    object.try(:grant_amount) || object.awards.sum(:amount)
  end
end
