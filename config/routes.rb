Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :petsitters, only: [:index, :show, :create, :new] do
    resources :bookings, only: [:create]
  end

  resources :bookings do
    member do
      patch :accept
      patch :decline
      patch :cancel
    end
    resources :reviews, only: [:create]
  end

  resources :reviews, only: [:index, :new, :update]

  resources :users, only: [:show] do
    member do
      get :phone_number
    end
  end
end
