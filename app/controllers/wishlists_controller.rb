class WishlistsController < ApplicationController
   before_action :authenticate_user!

  def index
    @wishlist = current_user.wishlist || current_user.create_wishlist
    @items = @wishlist.wishlist_items.includes(:product)

    respond_to do |format|
    format.html { redirect_back fallback_location: root_path }
    format.js   # create.js.erb
  end
end
end
