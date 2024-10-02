# frozen_string_literal: true

module Api
  module V1
    class TransactionsController < ActionController::API
      include Converter::ConversionMethods

      respond_to :json

      def create
        @transaction = Transaction.build(transaction_params)
        fromCoin = @transaction.fromCoin
        toCoin = @transaction.toCoin
        if COINS.dig(fromCoin, toCoin)
          converter = Converter.new
          amount = fromCoin == "BTC" \
            ? converter.btc_to_usd(@transaction.amount)
            : @transaction.amount
          user = @transaction.user
          if user.is_a?(User)
            if amount < user.balance
              if @transaction.save
                user.update(balance: user.balance-amount)
                converter = Converter.new
                render json: {
                  message: "Transaction created succesfully.",
                  data: {
                    amount_received: converter.send(COINS.dig(fromCoin, toCoin), amount)
                  }
                }, status: :ok
              else
                render json: { error: "Transaction could't be saved" }, status: :bad_request
              end
            else
              render json: { error: "You have no balance." }, status: :bad_request
            end
          else
            render json: { error: "User must exist" }, status: :unprocessable_entity
          end
        else
          render json: { error: "Invalid currency pair" }, status: :unprocessable_entity
        end
      end

      def list
        user = User.find(transaction_params[:user_id])
        if user.is_a?(User)
          @transactions = user.transactions
          if @transactions.respond_to?(:each)
            render json: { data: @transactions }, status: :ok
          else
            render json: { error: "Invalid user's transactions." }, status: :unprocessable_entity
          end
        else
          render json: { error: "No transactions found or invalid data." }, status: :unprocessable_entity
        end
      end

      def show
        byebug
        byebug
        id = params.extract_value(:id).first
        @transaction = Transaction.find(id)
        if @transaction.is_a?(Transaction)
          render json: { data: @transaction }, status: :ok
        else
          render json: { error: "Non existant transaction." }, status: :unprocessable_entity
        end
      end

      private

      def transaction_params
        params
          .require(:transaction)
          .permit(:fromCoin, :toCoin, :amount, :user_id)
      end
    end
  end
end
