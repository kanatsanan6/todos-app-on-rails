# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tasks#index'

  resources :tasks do
    resources :comments, only: %i[create edit update destroy]
  end
end
