# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models

  devise :database_authenticatable, :registerable, :validatable

  include DeviseTokenAuth::Concerns::User

  has_and_belongs_to_many :conversations

  validates :email, uniqueness: true
  validates :nickname, uniqueness: true
end
