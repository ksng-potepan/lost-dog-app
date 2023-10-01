Rails.application.routes.draw do
  get 'users/account'

  root to: 'home#top'
  devise_for :users
  resources :users
end
