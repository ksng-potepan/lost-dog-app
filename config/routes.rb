Rails.application.routes.draw do
  root to: 'home#top'
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  resources :users
end
