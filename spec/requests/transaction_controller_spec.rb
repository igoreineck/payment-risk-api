# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TransactionController', type: :request do
  describe 'POST /transactions' do
    context 'when the request is valid' do
      let(:payload) do
        {
          merchant_id: '29744',
          user_id: '97051',
          card_number: '434505******9116',
          transaction_date: Time.zone.now.iso8601,
          transaction_amount: 373,
          device_id: '285475'
        }
      end

      before { post '/api/transactions', params: payload }

      it 'returns status_code created' do
        expect(response).to have_http_status(201)
      end

      it 'returns the expected recommendation status' do
        expect(JSON.parse(response.body)['recommendation']).to eq('approved')
      end
    end

    context 'when the request is valid but the recommendation is not approved' do
      let(:merchant_id) { 1 }
      let(:user_id) { 1 }
      let!(:chargeback) do
        FactoryBot.create(
          :chargeback_history,
          merchant_id:,
          user_id:,
          chargeback_datetime: 1.day.ago
        )
      end

      let(:payload) do
        {
          merchant_id:,
          user_id:,
          card_number: '434505******9116',
          transaction_date: Time.zone.now.iso8601,
          transaction_amount: 373,
          device_id: '285475'
        }
      end

      before { post '/api/transactions', params: payload }

      it 'returns status_code created' do
        expect(response).to have_http_status(201)
      end

      it 'returns the expected recommendation status' do
        expect(JSON.parse(response.body)['recommendation']).to eq('denied')
      end
    end

    context 'when the request is not valid' do
      let(:merchant_id) { 1 }
      let(:user_id) { 1 }
      let(:payload) do
        {
          merchant_id:,
          user_id:,
          card_number: '434505******911600',
          transaction_date: Time.zone.now.iso8601,
          transaction_amount: 373,
          device_id: '285475'
        }
      end

      before { post '/api/transactions', params: payload }

      it 'returns status_code created' do
        expect(response).to have_http_status(422)
      end

      it 'returns an empty JSON body' do
        expect(response.body).to eq('{"message":["Card number is the wrong length (should be 16 characters)"]}')
      end
    end
  end

  describe 'GET /api/transactions/:id' do
    context 'when the :id is valid' do
      let!(:transaction) do
        FactoryBot.create(
          :transaction_history,
          merchant_id: 1,
          user_id: 1,
          card_number: '434505******9116',
          date: Time.zone.now.iso8601,
          device_id: '1'
        )
      end

      before { get "/api/transactions/#{transaction.id}" }

      it { expect(response).to have_http_status(200) }

      it 'returns the expected transaction content' do
        expect(JSON.parse(response.body)).to include(transaction.as_json)
      end
    end

    context 'when the :id is not valid' do
      before { get '/api/transactions/ab1' }

      it { expect(response).to have_http_status(404) }

      it 'returns an empty JSON body' do
        expect(response.body).to eq('{}')
      end
    end
  end
end
