class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show]

 def show
  @collection = Collection.find(params[:id])
  @collections = Collection.includes(:categories)
  

  @q = @collection.products
                  .joins(:product_variant_combinations)
                  .includes(:category, :product_variant_combinations)
                  .ransack(params[:q])

  @products = @q.result(distinct: true)
end


  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def product_to_json(product)
    {
      id: product.id,
      name: product.name,
      price: product.price,
      compare_price: product.compare_price,
      is_sale: product.compare_price.present? && product.compare_price > product.price,
      is_new: product.created_at >= 7.days.ago,
      featured_image_url: product.featured_image.attached? ? url_for(product.featured_image) : nil
    }
  end
  
end
