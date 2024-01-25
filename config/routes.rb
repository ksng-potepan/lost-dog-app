Rails.application.routes.draw do
  post 'users/update' => 'users#update'
  get  "information"  => "home#information"

  root to: 'home#top'
  devise_for :users, controllers: {
    sessions:      'users/sessions',
    registrations: "users/registrations"
  }
  resources :users, only: [:show, :edit, :update]
  resources :messages, only: [:create]
  resources :rooms, only: [:create, :index, :show]

  resources :sightings do
    collection do
      get 'information'
      get 'mysighting'
    end
    member do
      get 'list'
    end
  end
  resources :ambles do
    collection do
      get 'information'
      get 'myamble'
    end
    member do
      get 'list'
    end
  end
  resources :protects do
    collection do
      get 'information'
      get 'myprotect'
      get 'transferred'
    end
    member do
      get 'list'
    end
  end
end
