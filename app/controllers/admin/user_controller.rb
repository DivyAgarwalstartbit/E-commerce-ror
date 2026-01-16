# app/controllers/admin/users_controller.rb
module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: "User created successfully"
      else
        render :new
      end
    end

    private

    def require_admin
      redirect_to root_path, alert: "Not authorized" unless current_user.admin?
    end

    def user_params
     
      params.require(:user).permit(:email, :password, :password_confirmation, :role)
    end
  end
end
