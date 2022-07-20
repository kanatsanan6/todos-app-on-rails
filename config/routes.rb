# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tasks#index'

  resources :tasks do
    resources :comments
  end
end
