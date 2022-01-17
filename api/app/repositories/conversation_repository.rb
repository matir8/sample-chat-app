# frozen_string_literal: true

class ConversationRepository
  def find_by_id(id:)
    Conversation.includes(:users, :messages).find_by(id: id)
  end

  def find_by_users(ids:)
    Conversation.joins(:users).where(users: { id: ids }).find do |conversation|
      conversation.users.pluck(:id).sort == ids.sort
    end
  end

  def create!(user_ids:)
    Conversation.create!(users: User.where(id: user_ids))
  end

  def all_for_user(user_id:)
    Conversation.joins(:users).where(users: { id: [user_id] })
  end
end
