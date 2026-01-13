class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show]

  def show
   if @collection.name == "All"
    @collections = Collection.includes(:categories) # Load all collections and their categories
    @products = Product.includes(:featured_image_attachment,
                                 product_variant_combinations: :product_variant_options)
  else
    # Otherwise, load the selected collection's products
    @collections = [@collection] # Show only the selected collection
    @products = @collection.products.includes(:featured_image_attachment,
                                              product_variant_combinations: :product_variant_options)
  
      # Apply filters
      @products = filter_products(@products)
    end

    respond_to do |format|
      format.html
      format.json { render json: { products: @products.map { |p| product_to_json(p) } } }
    end
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

  # Filters products based on params
  def filter_products(products)
    # Filtering by Category (Many-to-many relation)
    if params[:category_id].present?
      products = products.where(category_id: params[:category_id])
    end

    # Filtering by Price
    products = products.where("price >= ?", params[:min_price].to_f) if params[:min_price].present?
    products = products.where("price <= ?", params[:max_price].to_f) if params[:max_price].present?

    # Size filter via product_variant_options
    if params[:size].present?
      products = products.joins(product_variant_combinations: :product_variant_options)
                         .where(product_variant_options: { variant_type: "size", value: params[:size] })
    end

    # Color filter via product_variant_options
    if params[:color].present?
      products = products.joins(product_variant_combinations: :product_variant_options)
                         .where(product_variant_options: { variant_type: "color", value: params[:color] })
    end

    products.distinct
  end
end
