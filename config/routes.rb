Rails.application.routes.draw do
  root "static_pages#home"
  get "contact", to: "static_pages#contact"

  resources :users
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
end
