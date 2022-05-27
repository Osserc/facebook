Rails.application.routes.draw do
  devise_for :users

  resources :users, :only => %i[ index show ]  do
    resources :posts
  end

  resources :friend_requests, :friendships, :followings, :blockings, :likes, :only => %i[ create destroy ]

  # post '/friend_requests/send_request', to: "friend_requests#send_requests", as: "register"
  # post '/friend_requests/unregister', to: "participations#unregister", as: "unregister"
  # post '/favorites/add_to_favorites', to: "favorites#add_to_favorites", as: "add_to_favorites"
  # post '/favorites/remove_from_favorites', to: "favorites#remove_from_favorites", as: "remove_from_favorites"
  # post '/invitations/generate_invite_list', to: "invitations#generate_invite_list", as: "generate_invite_list"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users#index"
end