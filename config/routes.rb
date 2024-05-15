Rails.application.routes.draw do
  root "static_pages#home"
  get "contact", to: "static_pages#contact"

  resources :users
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :sessions, only: %i(new create destroy)
  resources :password_resets, only: %i(new edit create update)
  resources :account_activations, only: :edit
end
