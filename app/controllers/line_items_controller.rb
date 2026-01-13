class LineItemsController < ApplicationController
  def create
    combination = ProductVariantCombination.find_by(id: params[:product_variant_combination_id])

    unless combination
      redirect_back fallback_location: root_path, alert: "Variant not found" and return
    end

    # Ensure quantity is valid
    quantity = params[:quantity].to_i
    quantity = 1 if quantity < 1

    # Add to current cart
    line_item = current_cart.line_items.find_or_initialize_by(product_variant_combination: combination)
    line_item.quantity ||= 0
    line_item.quantity = quantity
    line_item.price = combination.price

    if line_item.save
      redirect_to carts_path, notice: "Added to cart!"
    else
      Rails.logger.error("LineItem save failed: #{line_item.errors.full_messages.join(', ')}")
      redirect_back fallback_location: root_path, alert: "Could not add to cart"
    end
  end

  def destroy
    line_item = LineItem.find_by(id: params[:id])

    if line_item&.destroy
      respond_to do |format|
        format.html { redirect_to carts_path, notice: "Item removed from cart" }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: carts_path, alert: "Could not remove item" }
        format.json { render json: { error: "Could not remove item" }, status: :unprocessable_entity }
      end
    end
  end

  def update
    line_item = LineItem.find_by(id: params[:id])

    if line_item && line_item.update(line_item_params)
      respond_to do |format|
        format.html { redirect_to carts_path, notice: "Cart updated" }
        format.json { render json: { success: true, line_item: line_item }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: carts_path, alert: "Could not update cart" }
        format.json { render json: { error: "Could not update cart" }, status: :unprocessable_entity }
      end
    end
  end

  private

  def line_item_params
    params.require(:line_item).permit(:quantity)
  end
end
