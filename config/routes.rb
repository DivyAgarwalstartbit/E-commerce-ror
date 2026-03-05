Rails.application.routes.draw do
  
 # Normal Users
devise_for :users,
  path: '',
  path_names: { sign_in: 'login', sign_out: 'logout' },
  controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

# Admin login using the same User model
devise_scope :user do
  get    'admins/sign_in',  to: 'admins/sessions#new',     as: :new_admin_session
  post   'admins/sign_in',  to: 'admins/sessions#create',  as: :admin_session
  delete 'admins/logout',   to: 'admins/sessions#destroy', as: :destroy_admin_session
end
  # Remove the path_names section entirely, or use it correctly like:
  # path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }


  namespace :admins do
    root to: 'dashboards#index' 
    resources :orders
    resources :products 
    resources :collections
    resources :categories
    resources :conversations, only: [:index, :show]
    resources :customers do
    resources :billing_details, only: [:index]  # add this
  end
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
  resources :blogs , only: [:index]
  resources :contacts  ,only: [:index]
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