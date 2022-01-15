# frozen_string_literal: true

module Services
  module Conversations
    class FindOrCreate
      def initialize(participant_ids:, repo: ConversationRepository.new)
        @participant_ids = participant_ids
        @repo = repo
      end

      def call
        conversation = repo.find_by_users(ids: participant_ids)
        conversation ||= repo.create!(user_ids: participant_ids)

        conversation
      end

      private

      attr_reader :participant_ids, :repo
    end
  end
end


