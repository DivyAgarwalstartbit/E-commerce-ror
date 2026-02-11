module Admins
  class OrdersController < Admins::ApplicationController

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

    private

    def order_params
      params.require(:order).permit(:status)
    end

  end
end
