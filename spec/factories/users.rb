FactoryBot.define do
  factory :user do
    name { "John Doe" }
    email { "test@testing.com" }
    balance { 1000.0 }
  end
end
