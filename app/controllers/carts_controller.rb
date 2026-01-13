class CartsController < ApplicationController
  before_action :set_cart

  # GET /cart
  def index
    @line_items = @cart.line_items.includes(product_variant_combination: :product)
  end

  # POST /cart/add/:product_variant_combination_id
  def add_item
    combination = ProductVariantCombination.find(params[:product_variant_combination_id])

    if user_signed_in?
      @cart.add_variant(combination)
    else
      # Guest cart: create line_item manually
      line_item = @cart.line_items.find_or_initialize_by(product_variant_combination: combination)
      line_item.quantity ||= 0
      line_item.quantity += 1
      line_item.price = combination.price
      line_item.save!
    end

    redirect_to cart_path, notice: "#{combination.product.name} added to cart."
  end

  # PATCH /cart/update/:id
  def update_item
    line_item = @cart.line_items.find(params[:id])
    line_item.update(quantity: params[:quantity])
    redirect_to cart_path, notice: "Cart updated."
  end

  # DELETE /cart/remove/:id
  def remove_item
    line_item = @cart.line_items.find(params[:id])
    line_item.destroy
    redirect_to cart_path, notice: "Item removed from cart."
  end

  private

  def set_cart
    @cart = current_cart
  end
end
