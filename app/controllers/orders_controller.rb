class OrdersController < ApplicationController
  before_action :authenticate_user!

  def place_order
    billing = current_user.billing_details.find(params[:billing_detail_id])

    @order = Order.create!(
      user: current_user,
      billing_detail: billing,
      total_price: current_cart.total_amount,
      status: "pending"
    )
    current_cart.line_items.each do |item|
      item.update(order: @order, cart: nil)
    end
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: current_cart.line_items.map do |item|
        {
          price_data: {
            currency: 'usd',
            product_data: {
              name: item.product_variant_combination.product.name
            },
            unit_amount: (item.product_variant_combination.price * 100).to_i
          },
          quantity: item.quantity
        }
      end,
      mode: 'payment',
      success_url: success_orders_url(order_id: @order.id),
      cancel_url: cancel_orders_url(order_id: @order.id)
    )

    @order.update(stripe_session_id: session.id)

    redirect_to session.url, allow_other_host: true
  end


  def success
    @order = current_user.orders.find(params[:order_id])
    @order.update(status: "placed")

    current_cart.line_items.destroy_all

    redirect_to root_path, notice: "Payment successful 🎉"
  end


  def cancel
    @order = current_user.orders.find(params[:order_id])
    @order.update(status: "cancelled")

    redirect_to cart_path, alert: "Payment cancelled"
  end

end
