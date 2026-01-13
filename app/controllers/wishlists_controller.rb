class WishlistsController < ApplicationController
  def index
    # Avoid N+1 queries by including combinations and products
    @wishlist_items = current_wishlist
  end

  def create
  combination = ProductVariantCombination.find(params[:product_variant_combination_id])

  if user_signed_in?
    wishlist_item = Wishlist.find_or_create_by(user: current_user, product_variant_combination: combination)
    wishlist_count = current_user.wishlist_items.count
  else
    # Store only combination ID in session for guest
    session[:wishlist_ids] ||= []
    session[:wishlist_ids] << combination.id unless session[:wishlist_ids].include?(combination.id)
    wishlist_count = session[:wishlist_ids].size
  end

  respond_to do |format|
    format.html { redirect_back fallback_location: root_path, notice: "Added to wishlist" }
    format.json { render json: { wishlist_count: wishlist_count } }
  end
end

  def destroy
    if user_signed_in?
      wishlist_item = Wishlist.find(params[:id])
      wishlist_item.destroy if wishlist_item.user_id == current_user.id
    else
      # Remove combination ID from session for guest
      session[:wishlist_ids]&.delete(params[:id].to_i)
    end

    redirect_back fallback_location: wishlist_path, notice: "Removed from wishlist"
  end
end
