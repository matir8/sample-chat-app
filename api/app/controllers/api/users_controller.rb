# frozen_string_literal: true

class Api::UsersController < ApplicationController
  before_action :authenticate_api_user!

  def index
    query = params[:search]

    render json: UserSerializer.new(repository.get_all(query: query))
  end

  private

  def repository
    @repository ||= UserRepository.new
  end
end
