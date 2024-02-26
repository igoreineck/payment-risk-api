# frozen_string_literal: true

Rails.application.routes.draw do
  post 'api/transactions', to: 'transaction#create'
  get 'api/transactions/:id', to: 'transaction#show'
end
