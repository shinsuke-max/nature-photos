Rails.application.routes.draw do
  devise_for :users
  root 'staticpage#home'
end
