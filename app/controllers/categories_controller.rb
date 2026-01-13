class CategoriesController < ApplicationController
  def index
    @categories = Category.all

    # Start with all products
    @products = Product.includes(
      :featured_image_attachment,
      :featured_image_blob,
      product_variant_combinations: :product_variant_options
    )

    # Filter by category
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    # Filter by price
    if params[:min_price].present?
      @products = @products.where("price >= ?", params[:min_price])
    end

    if params[:max_price].present?
      @products = @products.where("price <= ?", params[:max_price])
    end

    # Filter by size
    if params[:size].present?
      @products = @products.joins(product_variant_combinations: :product_variant_options)
                           .where(product_variant_options: { variant_type: "size", value: params[:size] })
    end

    # Filter by color
    if params[:color].present?
      @products = @products.joins(product_variant_combinations: :product_variant_options)
                           .where(product_variant_options: { variant_type: "color", value: params[:color] })
    end

    # Remove duplicates after joins
    @products = @products.distinct
  end
end
