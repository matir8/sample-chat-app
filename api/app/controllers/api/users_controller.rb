# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    before_action :authenticate_api_user!

    def index
      query = prepared_params[:search]

      render json: UserSerializer.new(repository.get_all(query: query))
    end

    private

    def repository
      @repository ||= UserRepository.new
    end

    def prepared_params
      params.permit(:search)
    end
  end
end
