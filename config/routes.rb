Rails.application.routes.draw do
  
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  # Remove the path_names section entirely, or use it correctly like:
  # path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }

  devise_for :admins, skip: [:registrations], path: 'admins', path_names: {
    sign_in: 'sign_in',
    sign_out: 'sign_out'
  }, controllers: {
    sessions: 'admins/sessions'
  }

  namespace :admins do
    root to: 'dashboards#index' 
    resources :orders
    resources :products 
    resources :collections
    resources :categories
    resources :conversations, only: [:index, :show]
    resources :customers, only: [:index, :show]
  end

  root 'homes#index'
  resources :products, only: [:show]
  resources :collections, only: [:show]
  resources :categories, only: [:show]
  resources :line_items, only: [:create, :show, :update, :destroy]
  resources :wishlists, only: [:index]
  resources :wishlist_items, only: [:create, :destroy]
  resources :billing_details
  resources :carts, only: [:index]
  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end
  get 'start_chat', to: 'conversations#create', as: :start_chat
  post "/place_order", to: "orders#place_order"

  resources :orders do
    collection do
      get :success
      get :cancel
    end
  end
end