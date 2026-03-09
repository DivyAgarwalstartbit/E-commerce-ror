class WishlistItemsController < ApplicationController
  before_action :authenticate_user!

 def create
  wishlist = current_user.wishlist || current_user.create_wishlist
  product  = Product.find_by(id: params[:product_id])

  if product.nil?
    render json: { success: false, error: "Product not found" }, status: :unprocessable_entity
    return
  end

  existing = wishlist.wishlist_items.find_by(product_id: product.id)

  if existing
    existing.destroy
    render json: {
      success: true,
      action: "removed",
      wishlist_count: wishlist.wishlist_items.count
    }
  else
    item = wishlist.wishlist_items.create(product: product)

    if item.persisted?
      render json: {
        success: true,
        action: "added",
        wishlist_count: wishlist.wishlist_items.count
      }
    else
      render json: { success: false, errors: item.errors.full_messages }, status: 422
    end
  end
end
  def destroy
    wishlist = current_user.wishlist
    item     = wishlist.wishlist_items.find(params[:id])
    item.destroy
    redirect_to wishlists_path, notice: "Item removed from wishlist."
  end
end