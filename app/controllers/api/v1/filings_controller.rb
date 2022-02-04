module Api
  module V1
    class FilingsController < BaseController
      before_action :set_filer!, only: :index

      # GET /api/v1/filers/:filer_id/filings, GET /api/v1/filings
      def index
        @filings =  if @filer.present?
                      @filer.filings
                    else
                      Filing.all
                    end

        render json: @filings
      end

      # GET /api/v1/filings/:id
      def show
        @filing = Filing.find_by_id(params[:id])

        render json: { message: 'Filing Not Found' }, status: :not_found and return if @filing.nil?
        render json: @filing, full_details: true
      end

      private

      def set_filer!
        return unless params[:filer_id]

        @filer = Organization.filer.find_by_id(params[:filer_id])
        render json: { message: 'Filer Not Found' }, status: :not_found if @filer.nil?
      end
    end
  end
end
