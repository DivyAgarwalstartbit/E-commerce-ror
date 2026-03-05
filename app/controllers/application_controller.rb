class ApplicationController < ActionController::Base
  helper_method :current_cart, :current_account
  before_action :ensure_user_conversation, if: :user_signed_in?

  private

  def current_account
    current_user
  end

  def ensure_user_conversation
    current_user.conversations.find_or_create_by(status: "open")
  end

  # Only handles regular users now — admins handled in their own controller
  def after_sign_in_path_for(resource)
    if resource.has_role?(:admin)
      admins_root_path
    else
      root_path
    end
  end

  def current_cart
    if user_signed_in?
      cart = current_user.cart || current_user.create_cart
      if session[:cart_id]
        guest_cart = Cart.find_by(id: session[:cart_id])
        cart.merge!(guest_cart) if guest_cart
        session[:cart_id] = nil
      end
      cart
    else
      Cart.find_by(id: session[:cart_id]) || create_guest_cart
    end
  end

  def create_guest_cart
    cart = Cart.create!
    session[:cart_id] = cart.id
    cart
  end
end