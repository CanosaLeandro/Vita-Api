FactoryBot.define do
  factory :transactionBTC do
    fromCoin { "BTC" }
    toCoin { "USD" }
    amount { 0.0001 }
    association :user
  end

  factory :transactionUSD do
    fromCoin { "USD" }
    toCoin { "BTC" }
    amount { 100.00 }
    association :user
  end

  factory :bigTransactionBTC do
    fromCoin { "BTC" }
    toCoin { "USD" }
    amount { 100.00000000 }
    association :user
  end
end
