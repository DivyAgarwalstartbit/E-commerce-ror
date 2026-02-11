class WishlistItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    # Make sure the user has a wishlist
    wishlist = current_user.wishlist || current_user.create_wishlist

    # Ensure the product exists
    product = Product.find_by(id: params[:product_id])
    unless product
      redirect_back fallback_location: root_path, alert: "Product not found"
      return
    end

    # Add product if not already in wishlist
    item = wishlist.wishlist_items.find_or_initialize_by(product: product)

    if item.persisted?
      redirect_to wishlists_path, alert: "Product already in wishlist"
    elsif item.save
      redirect_to wishlists_path, notice: "Added to wishlist"
    else
      redirect_to wishlists_path, alert: "Could not add product to wishlist"
    end
  end

  def destroy
    wishlist = current_user.wishlist
    item = wishlist.wishlist_items.find(params[:id])
    item.destroy
    redirect_to wishlists_path, notice: "Removed from wishlist"
  end
end
