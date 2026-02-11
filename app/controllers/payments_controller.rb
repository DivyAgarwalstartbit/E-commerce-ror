class PaymentsController < ApplicationController
    def new 
    end 

    def create
  order = current_user.orders.find(params[:order_id])

  intent = Stripe::PaymentIntent.create(
    amount: (order.total_price * 100).to_i,
    currency: 'usd',
    metadata: {
      order_id: order.id,
      user_id: current_user.id
    }
  )

  payment = Payment.create!(
    user: current_user,
    order: order,
    stripe_payment_intent_id: intent.id,
    amount: intent.amount,
    currency: intent.currency,
    status: "pending"
  )

  render json: { client_secret: intent.client_secret }
end
end 