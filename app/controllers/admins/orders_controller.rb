module Admins
  class OrdersController < Admins::ApplicationController
    def new
  @order = Order.new
  @users = User.all
  @product_variants = ProductVariantCombination.includes(:product)
end

def create
  @order = Order.new(order_params)
  @order.status = "placed"

  line_items_params = (params[:order][:line_items] || {}).values

  # Filter out blank rows
  valid_items = line_items_params.select do |item|
    item[:product_variant_combination_id].present? && item[:quantity].to_i > 0
  end

  if valid_items.empty?
    @order.errors.add(:base, "Please add at least one product")
    @users = User.all
    @product_variants = ProductVariantCombination.includes(:product)
    render :new and return
  end

  if @order.save
    total = 0

    valid_items.each do |item|
      variant  = ProductVariantCombination.find(item[:product_variant_combination_id])
      quantity = item[:quantity].to_i
      price    = variant.price

      @order.line_items.create!(
        product_variant_combination: variant,
        quantity: quantity,
        price: price
      )

      total += price * quantity
    end

    @order.update(total_price: total)
    redirect_to admins_orders_path, notice: "Order created successfully."
  else
    @users = User.all
    @product_variants = ProductVariantCombination.includes(:product)
    render :new
  end
end




    def index
     @orders = Order.where.not(status: :pending)
                 .includes(:user, :billing_detail)
                 .order(created_at: :desc)
    end

    def show
     @order = Order.includes(line_items: { product_variant_combination: :product })
                .find(params[:id])
    end

    def edit 
        @order = Order.find(params[:id])
    end 

    def update
      @order = Order.find(params[:id])
      if @order.update(order_params)
        redirect_to admins_order_path(@order), notice: "Order updated"
      else
        render :show
      end
    end

    def destroy
    @order = Order.find(params[:id])
    if @order.destroy
      redirect_to admins_orders_path, notice: "Order Deleted"
    else
      redirect_to admins_orders_path, alert: "Order could not be deleted"
    end
  end

    private

    def order_params
      params.require(:order).permit(:user_id, :billing_detail_id, :status, :total_price)
    end

  end
end
