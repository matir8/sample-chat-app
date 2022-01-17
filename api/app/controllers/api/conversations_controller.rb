# frozen_string_literal: true

module Api
  class ConversationsController < ApplicationController
    before_action :authenticate_api_user!

    def index
      conversations = conversation_repository.all_for_user(user_id: current_api_user.id)

      render json: ConversationSerializer.new(conversations, { include: [:users] })
    end

    def create
      return render_error unless recipient.present?

      conversation =
        Conversations::FindOrCreate.new(participant_ids: participant_ids, repo: conversation_repository).call

      render json: ConversationSerializer.new(conversation, { include: [:users] })
    end

    private

    def render_error
      render json: { error: 'Invalid recipient' }, status: :bad_request
    end

    def conversation_repository
      @conversation_repository ||= ConversationRepository.new
    end

    def user_repository
      @user_repository ||= UserRepository.new
    end

    def recipient_id
      params.require(:recipient_id).to_i
    end

    def recipient
      @recipient ||= user_repository.find_by_id(id: recipient_id)
    end

    def participant_ids
      [current_api_user.id, recipient.id].uniq
    end
  end
end
