Rails.application.routes.draw do
  post 'users/update' => 'users#update'

  root to: 'home#top'
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  resources :users, only: [:show, :edit, :update]
  resources :ambles do
    collection do
      get 'information'
      get 'myamble'
    end
  end
  resources :protects do
    collection do
      get 'information'
      get 'myprotect'
      get 'trandferred'
    end
  end
end
