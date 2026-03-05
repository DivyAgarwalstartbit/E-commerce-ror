# app/controllers/admins/billing_details_controller.rb
module Admins
  class BillingDetailsController < Admins::ApplicationController
    def index
      user = User.find(params[:customer_id])
      billing_details = user.billing_details.select(:id, :street_address, :city, :state)
      render json: billing_details
    end
  end
end