# frozen_string_literal: true

class ConversationSerializer
  include JSONAPI::Serializer

  has_many :users
end
