# frozen_string_literal: true

class ConversationRepository
  def find_by_id(id:)
    Conversation.includes(:users, :messages).find_by(id: id)
  end
end
