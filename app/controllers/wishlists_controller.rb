class WishlistsController < ApplicationController


  def index
    @wishlist = current_user.wishlist || current_user.create_wishlist
    @items = @wishlist.wishlist_items.includes(:product)
  end
end
