# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  devise_for :users
  root 'tasks#index'

  resources :companies do
    resources :memberships, only: %i[index new create destroy]
  end

  resources :users

  resources :tasks do
    resources :comments, only: %i[create edit update destroy]
  end

  mount Sidekiq::Web => '/sidekiq'
end
