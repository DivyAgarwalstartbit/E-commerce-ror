module Admins
class DashboardsController < Admins::ApplicationController
  def index
    @total_customers = User.count
    @total_products  = Product.count
    @out_of_stock_products = ProductVariantCombination.where(stock_qunatity: 0).count
    @active_orders = Order.where(status: "placed").count

    @recent_customers = User
                             .order(created_at: :desc)
                             .limit(5)

    @low_stock_products = ProductVariantCombination.where("stock_qunatity > 0 AND stock_qunatity <= 5")
                                 .order(:stock)
                                 .limit(5)
  end
end 
end