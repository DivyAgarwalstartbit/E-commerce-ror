# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  def create
    super do
      current_cart # triggers merge
    end
  end
end
