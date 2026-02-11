class BillingDetailsController < ApplicationController
  before_action :set_billing_detail, only: [:edit, :update, :destroy]

  def index
    @billing_details = current_user.billing_details
  end

  def new
    @billing_detail = BillingDetail.new
  end

  def create
    @billing_detail = current_user.billing_details.build(billing_detail_params)

    if @billing_detail.save
      redirect_to billing_details_path, notice: "Address added successfully"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @billing_detail.update(billing_detail_params)
      redirect_to billing_details_path, notice: "Address updated successfully"
    else
      render :edit
    end
  end

  def destroy
    @billing_detail.destroy
    redirect_to billing_details_path, notice: "Address deleted"
  end

  private

  def set_billing_detail
    @billing_detail = current_user.billing_details.find(params[:id])
  end

  def billing_detail_params
    params.require(:billing_detail).permit(
      :first_name, :last_name, :street_address, :apartment_name,
      :city, :state, :country, :postal_code,
      :email, :phone_number
    )
  end
end
