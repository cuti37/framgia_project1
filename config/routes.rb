Rails.application.routes.draw do
  root "static_pages#home"
  get "/home", to: "static_pages#home"
  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  get "sessions/new"

  resources :users
end
