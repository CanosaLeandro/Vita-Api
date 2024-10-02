class Transaction < ApplicationRecord
  include Converter::ConversionMethods

  belongs_to :user
  validate :valid_coins

  private

  def valid_coins
    unless COINS[fromCoin][toCoin]
      errors.add(:base, "Invalid currency pair: #{fromCoin} to #{toCoin}")
    end
  end
end
