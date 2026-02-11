# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  def create
    conversation = Conversation.find(params[:conversation_id])
    sender = determine_sender
    message = conversation.messages.create!(message_params.merge(sender: sender))
    SupportChatChannel.broadcast_to(conversation, { body: message.body, sender: message.sender_type })
    head :ok
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end

  def determine_sender
    if request.referer&.include?('/admins/')
      current_admin
    else
      current_user
    end
  end
end
