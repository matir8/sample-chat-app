# frozen_string_literal: true

class MessageRepository
  def create!(conversation_id:, user_id:, content:)
    Message.create!(conversation_id: conversation_id, user_id: user_id, content: content)
  end

  def for_conversation(conversation_id:, page_number: 1, page_size: 10)
    Message.where(conversation_id: conversation_id)
           .order(created_at: :desc)
           .limit(page_size)
           .offset((page_number - 1) * page_size)
  end
end
