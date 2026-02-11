class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show]

  def show
    @collections = Collection.includes(:categories)

    base_scope =
      if @collection.id == 7
        Product.all
      else
        @collection.products
      end

    @q = base_scope
          .left_joins(:product_variant_combinations)
          .includes(:category, :product_variant_combinations)
          .ransack(params[:q])

    @products = @q.result(distinct: true)
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end
end
