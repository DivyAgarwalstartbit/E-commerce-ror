# app/controllers/admin/conversations_controller.rb
module Admins
class ConversationsController < Admins::ApplicationController
 

  def index
    @conversations = Conversation.all
  end

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages
  end
end
end 
