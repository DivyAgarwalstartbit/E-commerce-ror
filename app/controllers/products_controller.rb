class ProductsController <  ApplicationController
    def show
  @product = Product
    .includes(
      :product_variants,
      product_variant_combinations: :product_variants,
      featured_image_attachment: :blob
    )
    .find_by(slug: params[:id])

  unless @product
    redirect_to products_path, alert: "Product not found"
    return
  end

  # All available variant options (Size, Color, etc.)
  @variant_options = @product.product_variants.group_by(&:variant_type)

  # All variant combinations (SKU-level)
  @variant_combinations = @product.product_variant_combinations

  # Related products
  @related_products = Product
    .includes(:featured_image_attachment)
    .where(category_id: @product.category_id)
    .where.not(id: @product.id)
    .limit(4)

    respond_to do |format|
    format.html # default show.html.erb
    format.js   # renders show.js.erb
  end
end
                                                    
end
