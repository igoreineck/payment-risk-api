# frozen_string_literal: true

class TransactionController < ApplicationController
  def create
    @transaction_history = build_creation

    if @transaction_history.save
      render json: build_response, status: :created
    else
      render json: { message: @transaction_history.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @transaction_history = TransactionHistory.find_by(id: params[:id])

    if @transaction_history
      render json: @transaction_history, status: :ok
    else
      render json: {}, status: :not_found
    end
  end

  private

  def permitted_params
    params.permit(
      %i[id merchant_id user_id card_number transaction_date transaction_amount device_id]
    )
  end

  def build_creation
    TransactionHistory.new(
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
      transaction_id: @transaction_history.id,
      recommendation: @transaction_history.status
    }
  end
end
