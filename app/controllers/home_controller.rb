class HomeController < ApplicationController
  def index
    @hot_trends_products   = products_for("Hot Trends", 3)
    @feature_products      = products_for("Feature", 3)
    @best_seller_products  = products_for("Best Seller", 3)
    @mens_products         = products_for("Mens", 4)
    @womens_products       = products_for("Womens", 4)
    @all_products          = products_for_multiple(["Mens", "Womens"], 8)
  end

  private

  def products_for(collection_name, limit)
    collection = Collection.includes(products: [:featured_image_attachment, product_variant_combinations: :product_variant_options])
                           .find_by(name: collection_name)
    collection&.products&.limit(limit) || Product.none
  end

  def products_for_multiple(collection_names, limit)
    Product
      .joins(:collections)
      .includes(:featured_image_attachment, product_variant_combinations: :product_variant_options)
      .where(collections: { name: collection_names })
      .distinct
      .limit(limit)
  end
end
