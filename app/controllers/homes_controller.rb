class HomesController < ApplicationController
  def index
     @hot_trends_products   = featured_products_for("Hot Trends", 3)
    @feature_products      = featured_products_for("Featured", 3)
    @best_seller_products  = featured_products_for("Best sellers", 3)
    
    @mens_products         = featured_products_for("Men fashion")
    @womens_products       = featured_products_for("Women fashion")
    @all_products          = featured_products_for_multiple(["Men fashion", "Women fashion", "Kid fashion" , "Cosmetics" , "Accessories"])
  end

  private

  def featured_products_for(collection_name, limit = nil)
    collection = Collection
                   .includes(products: [:featured_image_attachment, product_variant_combinations: :product_variants])
                   .find_by(name: collection_name)

    return Product.none unless collection

    products = collection.products.select(&:featured)

    limit ? products.first(limit) : products
  end


  def featured_products_for_multiple(collection_names)
    Product
      .joins(:collections)
      .includes(:featured_image_attachment, product_variant_combinations: :product_variants)
      .where(collections: { name: collection_names }, featured: true)
      .distinct
  end
end
