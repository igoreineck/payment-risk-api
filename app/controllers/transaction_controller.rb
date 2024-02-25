# frozen_string_literal: true

class TransactionController < ApplicationController
  # {
  #   "transaction_id" : 2342357,
  #   "merchant_id" : 29744,
  #   "user_id" : 97051,
  #   "card_number" : "434505******9116",
  #   "transaction_date" : "2019-11-31T23:16:32.812632",
  #   "transaction_amount" : 373,
  #   "device_id" : 285475
  # }
  def create
    @transaction_history = build_creation

    if @transaction_history.valid?
      @transaction_history.tap { |th| th.status = 'approved' }.save

      render json: build_response, status: :created
    else
      @transaction_history.tap { |th| th.status = 'denied' }.save

      render json: build_response, status: :unprocessable_entity # error??
    end
  end

  private

  def permitted_params
    params.permit(
      %i[transaction_id merchant_id user_id card_number transaction_date transaction_amount device_id]
    )
  end

  def build_creation
    TransactionHistory.new(
      transaction_id: permitted_params[:transaction_id],
      merchant_id: permitted_params[:merchant_id],
      user_id: permitted_params[:user_id],
      card_number: permitted_params[:card_number],
      date: permitted_params[:transaction_date],
      amount: permitted_params[:transaction_amount],
      device_id: permitted_params[:device_id]
    )
  end

  def build_response
    {
      transaction_id: @transaction_history.transaction_id,
      recommendation: @transaction_history.status
    }
  end
end
