Rails.application.routes.draw do
  root "static_pages#home"
  get "/home", to: "static_pages#home"
  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  post "/signup", to: "user#create"
  get "sessions/new"
  delete "/logout", to: "sessions#destroy"

  resources :users
end
