# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      params = request.query_parameters

      token = params['access-token']
      uid = params['uid']
      client = params['client']

      self.current_user = find_verified_user(uid, token, client)
    end

    protected

    def repository
      @repository ||= UserRepository.new
    end

    def find_verified_user(email, token, client)
      user = repository.find_by_email(email: email)

      reject_unauthorized_connection unless user.present? && user.valid_token?(token, client)

      user
    end
  end
end
