class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Make these available in views
  helper_method :current_cart, :current_wishlist, :cart_count, :wishlist_count

  protected

  # Devise strong parameters
  def configure_permitted_parameters
    # Regular users cannot assign roles
    devise_parameter_sanitizer.permit(:sign_up, keys: [])
    devise_parameter_sanitizer.permit(:account_update, keys: [])
  end

  private

  ### -------------------------------
  ### CART LOGIC
  ### -------------------------------

  def current_cart
    if user_signed_in?
      current_user.cart || create_user_cart
    else
      guest_cart
    end
  end

  # Guest cart stored in session
  def guest_cart
    if session[:cart_id]
      Cart.find_by(id: session[:cart_id]) || create_guest_cart
    else
      create_guest_cart
    end
  end

  def create_guest_cart
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end

  # Create cart for logged-in user
  def create_user_cart
    cart = Cart.create(user: current_user)
    current_user.update(cart: cart)
    cart
  end

  ### -------------------------------
  ### WISHLIST LOGIC
  ### -------------------------------

  def current_wishlist
  if user_signed_in?
    # Signed-in users can load wishlists with associated product_variant_combination and product
    current_user.wishlists.includes(product_variant_combination: :product)
  else
    # For guest users, we need to manually load ProductVariantCombination from session
    guest_wishlist.includes(:product)
  end
end


  # Guest wishlist stored as session IDs of product_variant_combinations
  def guest_wishlist
  session[:wishlist_ids] ||= []
  # Load product_variant_combinations and eager-load products
  ProductVariantCombination.includes(:product).where(id: session[:wishlist_ids])
end

  # Add a product variant combination to guest wishlist
  def add_to_guest_wishlist(combination_id)
    session[:wishlist_ids] ||= []
    session[:wishlist_ids] << combination_id unless session[:wishlist_ids].include?(combination_id)
  end

  # Remove a product variant combination from guest wishlist
  def remove_from_guest_wishlist(combination_id)
    session[:wishlist_ids]&.delete(combination_id)
  end

  ### -------------------------------
  ### COUNTS
  ### -------------------------------

  def cart_count
    current_cart&.line_items&.sum(:quantity) || 0
  end

  def wishlist_count
    if user_signed_in?
      current_user.wishlists.count
    else
      session[:wishlist_ids]&.count || 0
    end
  end
end
