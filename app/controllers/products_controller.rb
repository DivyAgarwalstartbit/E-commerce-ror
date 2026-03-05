class ProductsController <  ApplicationController
   def show
  @product = Product
    .includes(
      :product_variants,
      featured_image_attachment: :blob,
      product_variant_combinations: [
        :product_variants,
        image_attachment: :blob,
        
      ]
    )
    .find_by(slug: params[:id])

  unless @product
    redirect_to root_path, alert: "Product not found" and return
  end

  @variant_options      = @product.product_variants.group_by(&:variant_type)
  @variant_combinations = @product.product_variant_combinations

  @related_products = Product
    .includes(:featured_image_attachment)
    .where(category_id: @product.category_id)
    .where.not(id: @product.id)
    .limit(4)

  @wishlist_product_ids = if user_signed_in?
    current_user.wishlist&.wishlist_items&.pluck(:product_id) || []
  else
    []
  end

  respond_to do |format|
    format.html
    format.js
  end
end
# In ProductsController#show
                                               
end
