# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             controllers: { registrations: 'registrations' }
  root 'posts#index'
  get '/users/:id', to: 'users#show', as: 'user'
  resources :posts do
    resources :comments, only: %i(create destroy)
    resources :likes, only: %i(create destroy)
  end
end
