# frozen_string_literal: true

class ConversationChannel < ActionCable::Channel::Base
  def subscribed
    return unless conversation_id.present?

    conversation = conversation_repository.find_by_id(id: conversation_id)

    return unless conversation.present?
    return unless conversation.accessible_for?(user_id: current_user.id)

    stream_from(conversation.id)
  end

  def send_message(data)
    content = data['message']
    attributes = {
      conversation_id: conversation_id,
      user_id: current_user.id,
      content: content
    }

    Messages::Create.new(attributes).call
  end

  private

  def message_repository
    @message_repository ||= MessageRepository.new
  end

  def conversation_repository
    @conversation_repository ||= ConversationRepository.new
  end

  def conversation_id
    params[:conversation_id].to_i
  end
end
