# frozen_string_literal: true

module Services
  module Messages
    class Create
      def initialize(conversation_id:, user_id:, content:)
        @conversation_id = conversation_id
        @user_id = user_id
        @content = content
      end

      def call
        raise 'Invalid conversation' unless conversation.present? && conversation.accessible_for?(user_id: user_id)
        raise 'Invalid user' unless user_id.present?
        raise 'Empty message passed' unless content.present?

        message = MessageRepository.new.create!(conversation_id: conversation.id, user_id: user.id, content: content)

        ActionCable.server.broadcast(conversation.id, message)
      end

      private

      attr_reader :conversation_id, :user_id, :content

      def conversation
        @conversation ||= ConversationRepository.new.find_by_id(id: conversation_id)
      end

      def user
        @user ||= UserRepository.new.find_by_id(id: user_id)
      end
    end
  end
end
