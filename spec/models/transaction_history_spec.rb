# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TransactionHistory', type: :model do
  context 'when the user has a chargeback with the same merchant in the last week' do
    let!(:chargeback) do
      FactoryBot.create(
        :chargeback_history,
        merchant_id:,
        user_id:,
        chargeback_datetime:
      )
    end

    let(:transaction) do
      FactoryBot.create(
        :transaction_history,
        merchant_id:,
        user_id:,
        card_number: '434505******9116',
        date: transaction_date,
        device_id: '1'
      )
    end

    let(:merchant_id) { 1 }
    let(:user_id) { 1 }
    let(:transaction_date) { Time.zone.now }
    let(:chargeback_datetime) { 1.day.ago }

    it 'returns the transaction status as denied' do
      expect(transaction.status).to eq('denied')
    end
  end

  context 'when the user has a chargeback with the same merchant more than a week ago' do
    let!(:chargeback) do
      FactoryBot.create(
        :chargeback_history,
        merchant_id:,
        user_id:,
        chargeback_datetime:
      )
    end

    let(:transaction) do
      FactoryBot.create(
        :transaction_history,
        merchant_id:,
        user_id:,
        card_number: '434505******9116',
        date: transaction_date,
        device_id: '1'
      )
    end

    let(:merchant_id) { 1 }
    let(:user_id) { 1 }
    let(:transaction_date) { Time.zone.now }
    let(:chargeback_datetime) { 8.days.ago }

    it 'returns the transaction status as approved' do
      expect(transaction.status).to eq('approved')
    end
  end

  context 'when the user has a chargeback with another merchant in the last week' do
    let!(:chargeback) do
      FactoryBot.create(
        :chargeback_history,
        merchant_id: 1,
        user_id:,
        chargeback_datetime:
      )
    end

    let(:transaction) do
      FactoryBot.create(
        :transaction_history,
        merchant_id: 2,
        user_id:,
        card_number: '434505******9116',
        date: transaction_date,
        device_id: '1'
      )
    end

    let(:user_id) { 1 }
    let(:transaction_date) { Time.zone.now }
    let(:chargeback_datetime) { 5.days.ago }

    it 'returns the transaction status as approved' do
      expect(transaction.status).to eq('approved')
    end
  end

  context 'when the transaction amount is greater than allowed' do
    let(:transaction) do
      FactoryBot.create(
        :transaction_history,
        merchant_id: 1,
        user_id: 1,
        card_number: '434505******9116',
        date: Time.zone.now,
        device_id: '1',
        amount: 1_000_000.00
      )
    end

    it 'throwns a validation error' do
      expect { transaction }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'when the card_number is not valid' do
    let(:transaction) do
      FactoryBot.create(
        :transaction_history,
        merchant_id: 1,
        user_id: 1,
        card_number: '1234567890ABCDEFG88',
        date: Time.zone.now,
        device_id: '1',
        amount: 199.99
      )
    end

    it 'throwns a validation error' do
      expect { transaction }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
