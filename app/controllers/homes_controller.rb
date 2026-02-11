class HomesController < ApplicationController
  def index
    @hot_trends_products   = featured_products_for("Hot Trends")
    @feature_products      = featured_products_for("Feature")
    @best_seller_products  = featured_products_for("Best Seller")
    @mens_products         = featured_products_for("Mens")
    @womens_products       = featured_products_for("Womens")
    @all_products          = featured_products_for_multiple(["Mens", "Womens", "Kids"])
  end

  private

  def featured_products_for(collection_name)
    collection = Collection.includes(products: [:featured_image_attachment, product_variant_combinations: :product_variants])
                           .find_by(name: collection_name)
    return Product.none unless collection

    
    collection.products.select(&:featured)
  end


  def featured_products_for_multiple(collection_names)
    Product
      .joins(:collections)
      .includes(:featured_image_attachment, product_variant_combinations: :product_variants)
      .where(collections: { name: collection_names }, featured: true)
      .distinct
  end
end
