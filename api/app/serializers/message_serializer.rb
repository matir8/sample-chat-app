# frozen_string_literal: true

class MessageSerializer
  include JSONAPI::Serializer

  attributes :content

  belongs_to :user
end
