# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  devise_for :users
  root 'companies#index'

  resources :companies do
    resources :memberships, only: %i[index new create destroy]
    resources :tasks do
      resources :comments, only: %i[create edit update destroy]
    end
  end

  resources :users

  mount Sidekiq::Web => '/sidekiq'
end
