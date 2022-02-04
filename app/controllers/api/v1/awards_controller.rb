module Api
  module V1
    class AwardsController < BaseController
      before_action :set_filing!, only: :index

      # GET /api/v1/filings/:filing_id/awards, GET /api/v1/awards
      def index
        @awards = if @filing.present?
                    @filing.awards
                  else
                    Award.all
                  end

        render json: @awards.includes([:filing, recipient: :address])
      end

      # GET /api/v1/awards/:id
      def show
        @award = Award.find_by_id(params[:id])

        render json: { message: 'Award Not Found' }, status: :not_found and return if @award.nil?
        render json: @award, full_details: true
      end

      private

      def set_filing!
        return unless params[:filing_id]

        @filing = Filing.find_by_id(params[:filing_id])
        render json: { message: 'Filing Not Found' }, status: :not_found if @filing.nil?
      end
    end
  end
end
