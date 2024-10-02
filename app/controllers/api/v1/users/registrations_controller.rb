# frozen_string_literal: true

module Api
  module V1
    class Users::RegistrationsController < Devise::RegistrationsController
      include RackSessionsFix

      respond_to :json

      private

      def respond_with(current_user, _opts = {})
        register_success && return if resource.persisted?
        register_failed
      end

      def register_success
        render json: {
            status: { code: 200, message: "Signed Up Successfully", data: resource }
          }, status: :ok
      end

      def register_failed
        render json: {
            status: { message: "User couldn't be Created. ", errors: resource.errors.full_messages.to_sentence }
          }, status: :unprocessable_entity
      end
    end
  end
end
