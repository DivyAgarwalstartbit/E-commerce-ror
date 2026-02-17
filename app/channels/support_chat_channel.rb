class SupportChatChannel < ApplicationCable::Channel
  def subscribed
    conversation = Conversation.find(params[:conversation_id])

    unless current_user.has_role?(:admin) || conversation.user == current_user
      reject
      return
    end
    stream_for conversation
  end
end