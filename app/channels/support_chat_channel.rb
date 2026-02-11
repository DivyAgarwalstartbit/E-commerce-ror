class SupportChatChannel < ApplicationCable::Channel
  def subscribed
    conversation = Conversation.find(params[:conversation_id])

    if current_account.is_a?(User) && conversation.user != current_account
    reject
    end

    stream_for conversation
  end
end