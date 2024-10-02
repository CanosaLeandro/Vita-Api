require "net/http"

module Api
  module V1
    class PricecheckController < ActionController::API
      respond_to :json

      def check_BTC
        converter = Converter.new
        if converter.btc_to_usd(1).is_a?(Float)
          render json: {
            data: {
              price: converter.btc_to_usd(1)
            }
          }
        else
          render json: { error: "Couldn't reach conversion" }, status: :bad_request
        end
      end
    end
  end
end
