class ProductsController < ApplicationController
  def index
    @products = Product.includes(:featured_image_attachment, :featured_image_blob).all
  end

  def show
    @product = Product.includes(
      :product_variant_options,
      product_variant_combinations: :product_variant_combination_options
    ).find_by(id: params[:id])

    unless @product
      redirect_to products_path, alert: "Product not found"
      return
    end

    @variant_options      = @product.product_variant_options
    @variant_combinations = @product.product_variant_combinations

    @related_products = Product
                        .includes(:featured_image_attachment, :featured_image_blob)
                        .where(category_id: @product.category_id)
                        .where.not(id: @product.id)
                        .limit(4)
  end
end
