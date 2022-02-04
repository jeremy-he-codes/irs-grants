module Api
  module V1
    class RecipientsController < BaseController
      # GET /api/v1/recipients
      def index
        @recipients = Organization.recipient.includes(:address).joins(awards: :filing)
                        .select('organizations.*, SUM(awards.amount) AS grant_amount')
                        .group('organizations.id')
        search

        render json: @recipients, each_serializer: RecipientSerializer, include_sum: true
      end

      # Get /api/v1/recipients/:id
      def show
        @recipient = Organization.find_by_id(params[:id])

        render json: { message: 'Recipient Not Found' }, status: :not_found and return if @recipient.nil?
        render json: @recipient, serializer: RecipientSerializer, full_details: true, include_sum: true
      end

      private

      def search
        @recipients = @recipients.where('filings.tax_year = ?', params[:tax_year]) if params[:tax_year].present?
        @recipients = @recipients.having('grant_amount >= ?', params[:amount_from].to_i) if params[:amount_from].present?
        @recipients = @recipients.having('grant_amount <= ?', params[:amount_to].to_i) if params[:amount_to].present?
      end
    end
  end
end

# As for the time constraint, pagination is skipped
