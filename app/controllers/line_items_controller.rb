# app/controllers/line_items_controller.rb
class LineItemsController < ApplicationController
    def update
    line_item = current_cart.line_items.find(params[:id])

    if line_item.update(quantity: params[:line_item][:quantity])
      redirect_to carts_path, notice: "Cart updated successfully"
    else
      redirect_to carts_path, alert: "Failed to update item"
    end
  end

  def destroy
    line_item = current_cart.line_items.find(params[:id])
    line_item.destroy

    redirect_to carts_path, notice: "Item removed from cart"
  end


  def create
    cart = current_cart

    variant_id = params[:product_variant_combination_id]
    quantity   = params[:quantity].to_i

    return redirect_back fallback_location: root_path, alert: "Invalid quantity" if quantity <= 0

     line_item = cart.line_items.find_by(
      product_variant_combination_id: variant_id
    )

    if line_item
      # If variant already exists, increase quantity
      line_item.quantity += quantity
    else
      # Otherwise create new line item
      line_item = cart.line_items.new(
        product_variant_combination_id: variant_id,
        quantity: quantity
      )
    end

    if line_item.save
      redirect_to carts_path, notice: "Added to cart"
    else
      redirect_back fallback_location: root_path, alert: "Could not add to cart"
    end
  end
end
