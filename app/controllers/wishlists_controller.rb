class WishlistsController < ApplicationController
   before_action :authenticate_user!

  def index
    @wishlist = current_user.wishlist || current_user.create_wishlist
    @items = @wishlist.wishlist_items.includes(:product)

    
  
end
end
