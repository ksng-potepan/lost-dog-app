Rails.application.routes.draw do
  post 'users/update' => 'users#update'

  root to: 'home#top'
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  resources :users, only: [:show, :edit, :update]
end
