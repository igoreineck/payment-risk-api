# frozen_string_literal: true

Rails.application.routes.draw do
  post 'api/transactions', to: 'transaction#create'
end
