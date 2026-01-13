Rails.application.routes.draw do
  
  devise_for :users, controllers: {
  sessions: "users/sessions"
}

  namespace :admin do
    root 'dashboard#index'
    resources :products
  resources :collections
  resources :categories
  resources :product_variants
  resources :users
  end

  root 'home#index'
  resources :wishlists
  resources :orders
  resources :line_items
  resources :carts
  resources :products, only: [:index, :show]
  resources :collections, only: [:index , :show]
  resources :categories, only: [:index , :show]
end
