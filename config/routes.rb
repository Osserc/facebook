Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users, only: %i[ index show ]  do
    resources :posts do
      resources :comments
    end
    resources :notifications, only: %i[ index show ] do
      member do
        post :read
      end
    end
    resources :profiles, only: %i[ edit update ]
  end

  resources :comments do
    member do
      post :more
      post :less
    end
    resources :comments
  end

  resources :friend_requests, :friendships, :followings, :blockings, :likes, only: %i[ create destroy ]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users#index"
end