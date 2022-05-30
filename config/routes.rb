Rails.application.routes.draw do
  devise_for :users

  resources :users, only: %i[ index show ]  do
    resources :posts do
      resources :comments
    end
  end

  resources :comments do
    resources :comments
  end

  resources :friend_requests, :friendships, :followings, :blockings, :likes, only: %i[ create destroy ]
  resources :comments, except: %i[ index show ]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users#index"
end