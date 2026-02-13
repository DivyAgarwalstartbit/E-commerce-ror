# app/controllers/conversations_controller.rb
class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = current_user.conversations
  end

end
