# frozen_string_literal: true

class MessageSerializer
  include JSONAPI::Serializer

  attributes :content, :created_at

  belongs_to :user
end
