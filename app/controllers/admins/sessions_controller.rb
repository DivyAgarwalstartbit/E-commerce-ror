class Admins::SessionsController < Devise::SessionsController
  layout "admin"
  
  # This inherits from Devise::SessionsController NOT Admins::ApplicationController
  # so require_admin never runs here — no skip needed

  def new
    if user_signed_in? && current_user.has_role?(:admin)
      redirect_to admins_root_path and return
    end
    super
  end

  def create
    self.resource = warden.authenticate!(auth_options)

    unless resource&.has_role?(:admin)
      sign_out resource if resource
      redirect_to new_admin_session_path, alert: "Access denied."
      return
    end

    sign_in(resource_name, resource)
    clear_stored_location_for(resource)
    redirect_to admins_root_path, notice: "Signed in successfully."
  end

  def destroy
    sign_out(current_user)
    redirect_to new_admin_session_path, notice: "Signed out successfully."
  end

  private

  def after_sign_in_path_for(resource)
    admins_root_path
  end

  def after_sign_out_path_for(resource)
    new_admin_session_path
  end
end

