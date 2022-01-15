# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth'

    resources :users, only: %i[index]

    resources :conversations, only: %i[index create] do
      resources :messages, only: %i[index]
    end
  end

  mount ActionCable.server => '/chat'
end
