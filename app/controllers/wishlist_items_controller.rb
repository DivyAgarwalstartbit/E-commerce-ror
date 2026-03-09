class WishlistItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    wishlist = current_user.wishlist || current_user.create_wishlist
    product  = Product.find_by(id: params[:product_id])

    unless product
      render json: { success: false, error: "Product not found" }, status: :not_found and return
    end

    existing = wishlist.wishlist_items.find_by(product: product)

    if existing
      # Toggle OFF — remove from wishlist
      existing.destroy
      render json: {
        success: true,
        action: "removed",
        wishlist_count: wishlist.wishlist_items.count
      }
    else
      # Toggle ON — add to wishlist
      item = wishlist.wishlist_items.create!(product: product)
      render json: {
        success: true,
        action: "added",
        wishlist_count: wishlist.wishlist_items.count
      }
    end
  end

  def destroy
    wishlist = current_user.wishlist
    item     = wishlist.wishlist_items.find(params[:id])
    item.destroy
    redirect_to wishlists_path, notice: "Item removed from wishlist."
  end
end