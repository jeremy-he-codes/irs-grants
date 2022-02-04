class BaseSerializer < ActiveModel::Serializer
  def full_details?
    instance_options[:full_details]
  end
end
