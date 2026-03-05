class CollectionsController < ApplicationController
  before_action :set_collection

  def show
    base_scope =
      if @collection.name == "All products"
        Product.includes(:category, :product_variant_combinations, :product_variants)
      else
        @collection.products.includes(:category, :product_variant_combinations, :product_variants)
      end

    # Use Ransack with associations
    @q = base_scope.ransack(params[:q])
    @products = @q.result(distinct: true)
    @wishlist_product_ids = if user_signed_in?
  current_user.wishlist&.wishlist_items&.pluck(:product_id) || []
else
  []
end
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
    if @collection.name == "All products"
      @collections = Collection.includes(:categories)
    else 
      @collection = Collection.find(params[:id])
    end 
  end
end
