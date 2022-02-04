class FilingSerializer < BaseSerializer
  attributes :id, :tax_year, :period_begin_date, :period_end_date
  belongs_to :filer, serializer: FilerSerializer, if: :full_details?

  def period_begin_date
    object.period_begin_date&.strftime("%Y-%m-%d")
  end

  def period_end_date
    object.period_end_date&.strftime("%Y-%m-%d")
  end
end
