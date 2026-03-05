module Admins
  class CustomersController < Admins::ApplicationController
    

  def new
    @customer = User.new
  end

  def create
    @customer = User.new(customer_params)
    if @customer.save
      redirect_to admins_customers_path, notice: "Customer created successfully"
    else
      render :new
    end
  end

    def index
      @customers = User.all.order(created_at: :desc)
    end

    def show
      @customer = User.find(params[:id])
      @orders = @customer.orders.where.not(status: "pending")
    end

    def destroy 
      @customer = User.find(params[:id])
        if @customer.destroy
            redirect_to admins_customers_path, notice: "customer Deleted"
          else
            redirect_to admins_customers_path, alert: "Customer could not be deleted"
          end
    end
    private 


    def customer_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end


  end
end
