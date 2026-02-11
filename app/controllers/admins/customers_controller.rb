module Admins
  class CustomersController < Admins::ApplicationController

    def index
      @customers = User.all.order(created_at: :desc)
    end

    def show
      @customer = User.find(params[:id])
      @orders = @customer.orders.where.not(status: "pending")
    end

  end
end
