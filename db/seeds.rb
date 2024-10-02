# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
user = User.create(email: "test@test.com", password: "1234", name: "Test", balance: 500)

transactions = Transaction.create([
  { fromCoin: "BTC", toCoin: "USD", amount: 0.00000001, user: user },
  { fromCoin: "USD", toCoin: "BTC", amount: 10.20, user: user },
  { fromCoin: "BTC", toCoin: "USD", amount: 0.00000002, user: user },
  { fromCoin: "USD", toCoin: "BTC", amount: 30.40, user: user }
])
