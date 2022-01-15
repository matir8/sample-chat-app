# frozen_string_literal: true

require_relative '../../services/conversations/find_or_create'

module Api
  class MessagesController < ApplicationController
    before_action :authenticate_api_user!

    def index
      messages = message_repository.for_conversation(prepared_params)

      render json: MessageSerializer.new(messages)
    end

    private

    def message_repository
      @message_repository ||= MessageRepository.new
    end

    def prepared_params
      params.permit(:conversation_id, :page_number, :page_size).to_h.each_with_object({}) do |(k, v), acc|
        acc[k.to_sym] = v.to_i
      end
    end
  end
end
