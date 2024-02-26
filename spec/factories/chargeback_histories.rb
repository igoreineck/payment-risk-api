# frozen_string_literal: true

FactoryBot.define do
  factory :chargeback_history do
    merchant_id { '29744' }
    user_id { '97051' }
    chargeback_datetime { '2019-11-31T23:16:32.812632' }
  end
end
