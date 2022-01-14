# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer

  attributes :name, :nickname
end
