# frozen_string_literal: true

class TransactionHistory < ApplicationRecord
  CHARGEBACK_TIME_TRESHOLD = 1.week

  enum :status, %i[approved denied], preffix: true

  validates :card_number, presence: true, length: { is: 16 }
  validates :amount, numericality: { less_than_or_equal_to: 99_999.99 }

  before_commit :validate_transaction

  private

  def validate_transaction
    self.status = transaction_invalid? ? :denied : :approved
  end

  def transaction_invalid?
    chargeback.present? && (Time.now - chargeback.chargeback_datetime) <= CHARGEBACK_TIME_TRESHOLD
  end

  def chargeback
    @chargeback ||= ChargebackHistory
                    .where(merchant_id:, user_id:)
                    .order(chargeback_datetime: :desc)
                    .limit(1)
                    .first
  end
end
