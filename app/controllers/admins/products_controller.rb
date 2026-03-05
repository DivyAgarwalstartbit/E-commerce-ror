module Admins
    class ProductsController < Admins::ApplicationController
        before_action :set_product, only: [:edit, :update, :show, :inventory , :destroy]

        def index 
          @products = Product.includes(:category).all
        end
        
        def new
          @product = Product.new
          @product.product_variants.build 
        end

         def create
         @product = Product.new(product_params)
        if @product.save

             prices = params[:product][:combination_prices]
             stocks = params[:product][:combination_stock]
            compared  = params[:product][:combination_compared_prices]
            images = params[:product][:combination_images] || []

            groups = @product.variant_groups.values
            combinations = groups.shift.product(*groups)

             combinations.each_with_index do |variants, index|
      pvc = @product.product_variant_combinations.create!(
        price: prices[index],
        compared_price: compared[index],
       stock_qunatity: stocks[index]
      )
      pvc.product_variants << variants
      if images[index].present?
  pvc.image.attach(images[index])
end
    end
            redirect_to admins_products_path, notice: "Product created!"
        else
            render :new
        end
        end
        
       def edit
  @product = Product.find_by!(slug: params[:id])

  groups = @product.variant_groups.values
  return if groups.empty?

  combinations = groups.shift.product(*groups)

  @existing_combinations = combinations.map do |variants|
    variant_array = Array(variants)

    pvc = @product.product_variant_combinations.includes(:product_variants).find do |c|
      c.product_variant_ids.sort == variant_array.map(&:id).sort
    end

    {
      variants:      variant_array.map(&:value),
      price:         pvc&.price,
      compared_price: pvc&.compared_price,
      stock:         pvc&.stock_qunatity,
      image_url:     pvc&.image&.attached? ? url_for(pvc.image) : nil
    }
  end
end
        def update
  @product = Product.find_by!(slug: params[:id])

  if @product.update(product_params)
    prices   = params[:product][:combination_prices] || []
    compare  = params[:product][:combination_compared_prices] || []
    stocks   = params[:product][:combination_stock] || []
    images   = params[:product][:combination_images] || []

    groups       = @product.variant_groups.values
    combinations = groups.shift.product(*groups)

    combinations.each_with_index do |variants, index|
      variant_array = Array(variants)

      # Find existing PVC by matching variant IDs instead of building new ones
      pvc = @product.product_variant_combinations.find do |c|
        c.product_variant_ids.sort == variant_array.map(&:id).sort
      end

      next unless pvc  # skip if no match found

      pvc.price          = prices[index]
      pvc.compared_price = compare[index]
      pvc.stock_qunatity = stocks[index]
      pvc.save!

      if images[index].present?
        pvc.image.purge if pvc.image.attached?
        pvc.image.attach(images[index])
      end
    end

    redirect_to admins_products_path, notice: "Product updated!"
  else
    render :edit
  end
end

        def destroy

          if @product.destroy
            redirect_to admins_products_path, notice: "Product Deleted"
          else
            redirect_to admins_products_path, alert: "Product could not be deleted"
          end
        end
 

        private

         def set_product
         @product = Product.find_by!(slug: params[:id])
         end


        def product_params
      params.require(:product).permit(
        :name,
        :description,
        :slug,
        :short_description,
        :brand,
        :category_id,
        :featured,
        :featured_image,
        product_variants_attributes: [
          :id,
          :variant_type,
          :value,
          :_destroy
        ]
      )
    end
        
    end
end