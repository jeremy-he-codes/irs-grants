module Api
  module V1
    class FilersController < BaseController
      # GET /api/v1/filers
      def index
        @filers = Organization.filer.includes(:address)

        render json: @filers, each_serializer: FilerSerializer
      end

      # GET /api/v1/filers/:id
      def show
        @filer = Organization.find_by_id(params[:id])

        render json: { message: 'Filer Not Found' }, status: :not_found and return if @filer.nil?
        render json: @filer, serializer: FilerSerializer
      end
    end
  end
end

# As for the time constraint, pagination is skipped
