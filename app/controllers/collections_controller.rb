class CollectionsController < ApplicationController
  before_action :set_collection

  def show
    base_scope =
      if @collection.id == 7
        Product.includes(:category, :product_variant_combinations, :product_variants)
      else
        @collection.products.includes(:category, :product_variant_combinations, :product_variants)
      end

    # Use Ransack with associations
    @q = base_scope.ransack(params[:q])
    @products = @q.result(distinct: true)
    @collections = Collection.includes(:categories)
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end
end
