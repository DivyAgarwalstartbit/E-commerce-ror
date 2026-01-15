class Admin::ProductsController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  private

  def product_params
    params.require(:product).permit(:name, :short_description, :description, :brand, :price, :compare_price, :specification, :category_id, :featured_image)
  end
end
