# frozen_string_literal: true

class TransactionHistory < ApplicationRecord
  validates :card_number, presence: true, length: { is: 16 }
  validates :status, inclusion: { in: %w[approved denied] }
  validates :amount, numericality: { greater_than: 99_999.99 }

  before_commit :transaction_invalid?

  private

  def transaction_invalid?
    return true if chargeback.present? && (Time.now - chargeback.chargeback_datetime) <= 1.day

    false
  end

  def chargeback
    @chargeback ||= ChargebackHistory
                    .where(:merchant_id, :user_id)
                    .order_by(chargeback_datetime: :desc)
                    .limit(1)
  end
end
