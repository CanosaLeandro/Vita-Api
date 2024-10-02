# frozen_string_literal: true

module Api
  module V1
    class Users::SessionsController < Devise::SessionsController
      include RackSessionsFix

      respond_to :json

      private

      def respond_with(current_user, _opts = {})
      render json: {
        message: "You are logged in.",
        user: current_user
      }, status: :ok
      end

      def respond_to_on_destroy
        header = request.headers["authorization"].split(" ")[1]
        key = Rails.application.credentials.fetch(:secret_key_base)
        jwt_payload = JWT.decode(header, key).first
        current_user = User.find(jwt_payload["sub"])
        log_out_success && return if current_user
        log_out_failure
      end

      private

      def log_out_success
        render json: { message: "You are logged out." }, status: :ok
      end

      def log_out_failure
        render json: { message: "logout failed !!" }, status: :unauthorized
      end
    end
  end
end
