module Admins
  class ApplicationController < ActionController::Base
    layout "admin"
    include Devise::Controllers::Helpers

    before_action :require_admin

    private

    def require_admin
      unless user_signed_in? && current_user.has_role?(:admin)
        # Prevent redirect loop — don't redirect if already going to sign_in
        redirect_to new_admin_session_path, alert: "Access denied." unless request.path == new_admin_session_path
      end
    end
  end
end