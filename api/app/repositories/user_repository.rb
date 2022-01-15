# frozen_string_literal: true

class UserRepository
  def get_all(query: nil)
    return User.all unless query.present?

    query = sanitize_like_query(query)
    table = User.arel_table

    User.where(table[:name].matches(query)).or(User.where(table[:nickname].matches(query)))
  end

  def find_by_email(email:)
    User.find_by(email: email)
  end

  def find_by_id(id:)
    User.find_by(id: id)
  end

  private

  def sanitize_like_query(query)
    "%#{ActiveRecord::Base.sanitize_sql_like(query)}%"
  end
end
