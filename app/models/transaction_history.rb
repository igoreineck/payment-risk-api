# frozen_string_literal: true

class TransactionHistory < ApplicationRecord
  CHARGEBACK_TIME_TRESHOLD = 1.week.ago
  LAST_PURCHASE_TRESHOLD = 10.minutes

  validates :card_number, presence: true, length: { is: 16 }
  validates :amount, numericality: { less_than_or_equal_to: 99_999.99 }

  before_save :validate_transaction
  after_save :set_chargeback

  private

  def validate_transaction
    self.status = 'denied' if chargeback? || recently_purchased?
  end

  # @TODO: add card_number as a complement for chargeback generation
  # it does not make sense to have a fixed chargeback between only the (merchant <> user)
  def set_chargeback
    ChargebackHistory.create(merchant_id:, user_id:, chargeback_datetime: Time.zone.now) if status == 'denied'
  end

  def chargeback?
    ChargebackHistory.exists?(merchant_id:, user_id:, chargeback_datetime: CHARGEBACK_TIME_TRESHOLD..)
  end

  def recently_purchased?
    self.class
        .where(merchant_id:, user_id:, card_number:)
        .where('date >= ?', date - LAST_PURCHASE_TRESHOLD)
        .order(date: :desc)
        .present?
  end
end
