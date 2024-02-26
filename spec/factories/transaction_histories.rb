# frozen_string_literal: true

FactoryBot.define do
  factory :transaction_history do
    merchant_id { '29744' }
    user_id { '97051' }
    card_number { '434505******9116' }
    date { '2019-11-31T23:16:32.812632' }
    amount { 373 }
    device_id { '285475' }
  end
end
