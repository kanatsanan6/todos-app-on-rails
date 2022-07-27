# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'tasks#index'

  resources :users

  resources :tasks do
    resources :comments, only: %i[create edit update destroy]
  end
end
