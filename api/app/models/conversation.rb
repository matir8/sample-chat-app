# frozen_string_literal: true

class Conversation < ApplicationRecord
  has_many :messages
  has_and_belongs_to_many :users

  def accessible_for?(user_id:)
    users.pluck(:id).include?(user_id)
  end
end
