# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TransactionController', type: :request do
  let(:transaction) do
    {
      transaction_id: '2342357',
      merchant_id: '29744',
      user_id: '97051',
      card_number: '434505******9116',
      transaction_date: '2019-11-31T23:16:32.812632',
      transaction_amount: 373,
      device_id: '285475'
    }
  end

  describe 'POST /transactions' do
    it 'alas' do
      post :create


    end
  end
end
