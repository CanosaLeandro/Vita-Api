require 'rails_helper'

RSpec.describe 'Transactions API', type: :request do
  let(:user) { create(:user) }
  let!(:transactionBTC) { create(:transactionBTC, user: user) }
  let!(:transactionUSD) { create(:transactionUSD, user: user) }
  let!(:bigTransaction) { create(:bigTransactionBTC, user: user) }
  let(:transaction_id) { 1 }

  describe 'POST /api/v1/transactions' do
    let(:valid_attributes) do
      {
        transaction: {
          fromCoin: 'USD',
          toCoin: 'BTC',
          amount: 3.0,
          user_id: user.id
        }
      }
    end

    it 'creates a transaction' do
      expect {
        post '/api/v1/transactions', params: valid_attributes
      }.to change(Transaction, :count).by(1)

      expect(response).to have_http_status(:ok)
      expect(json['message']).to eq('Transaction created succesfully.')
    end

    it 'returns an error if user does not exist' do
      post '/api/v1/transactions', params: valid_attributes.merge(user_id: nil)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['error']).to include("User must exist")
    end
  end

  describe 'GET /api/v1/transactions/:id' do
    let (:show_params) do
      {
        transaction: {
          user_id: user.id
        }
      }
    end

    it 'retrieves a transaction' do
      get "/api/v1/transactions/#{transaction_id}", params: show_params

      expect(response).to have_http_status(:ok)
      expect(json['data']['id']).to eq(transaction_id)
    end

    it 'returns an error if transaction does not exist' do
      get '/api/v1/transactions/99999'

      expect(response).to have_http_status(:not_found)
      expect(json['error']).to eq("Non existant transaction.")
    end
  end

  describe 'GET /api/v1/transactions/list' do
    it 'lists all transactions for a user' do
      get '/api/v1/transactions/list', params: { user_id: user.id }

      expect(response).to have_http_status(:ok)
      expect(json['data']).to be_an(Array)
      expect(json['data'].size).to eq(5)
    end

    it 'returns an error if no transactions exist' do
      get '/api/v1/transactions/list', params: { user_id: create(:user).id }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['error']).to eq('No transactions found or invalid data.')
    end
  end
end
