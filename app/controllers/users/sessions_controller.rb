class Users::SessionsController < Devise::SessionsController
  def create
    super do |user|
      merge_guest_cart(user)
    end
  end

  private

  def merge_guest_cart(user)
    return unless session[:cart_id]

    guest_cart = Cart.find_by(id: session[:cart_id])
    user_cart = user.cart || Cart.create(user: user)

    guest_cart.line_items.each do |item|
      existing = user_cart.line_items.find_by(product_variant: item.product_variant)

      if existing
        existing.quantity += item.quantity
        existing.save
      else
        item.update(cart: user_cart)
      end
    end

    guest_cart.destroy
    session[:cart_id] = nil
  end
end
