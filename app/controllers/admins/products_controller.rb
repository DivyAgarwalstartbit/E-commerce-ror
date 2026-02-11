module Admins
    class ProductsController < Admins::ApplicationController
        before_action :set_product, only: [:edit, :update, :show, :inventory]

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

            groups = @product.variant_groups.values
            combinations = groups.shift.product(*groups)

             combinations.each_with_index do |variants, index|
      pvc = @product.product_variant_combinations.create!(
        price: prices[index],
        compared_price: compared[index],
       stock_qunatity: stocks[index]
      )
      pvc.product_variants << variants
    end
            redirect_to admins_products_path, notice: "Product created!"
        else
            render :new
        end
        end
        
        def edit 
          @product = Product.find_by!(slug: params[:id])
        end 
  
        def update
  # Find the product
  @product = Product.find_by!(slug: params[:id])

  if @product.update(product_params)
    if params[:product][:featured_image].present?
      @product.featured_image.attach(params[:product][:featured_image])
    end
    # Handle combination prices / stock / compared prices if sent
    prices  = params[:product][:combination_prices] || []
    compare = params[:product][:combination_compared_prices] || []
    stocks  = params[:product][:combination_stock] || []

    # Generate combinations (similar to create)
    groups = @product.variant_groups.values
    combinations = groups.shift.product(*groups)

    combinations.each_with_index do |variants, index|
      # Find existing combination or create new
      pvc = @product.product_variant_combinations.find_or_initialize_by(
        product_variants: variants
      )

      pvc.price          = prices[index]
      pvc.compared_price = compare[index]
      pvc.stock_quantity = stocks[index]
      pvc.save!
    end

    redirect_to admins_product_path(@product), notice: "Product updated!"
  else
    # If update fails, re-render form with errors
    render :edit
  end
end

        def destroy
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