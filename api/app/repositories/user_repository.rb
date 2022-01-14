# frozen_string_literal: true

class UserRepository
  def get_all(query: nil)
    return User.all unless query.present?

    query = sanitize_like_query(query)
    table = User.arel_table

    User.where(table[:name].matches(query)).or(User.where(table[:nickname].matches(query)))
  end

  private

  def sanitize_like_query(query)
    "%#{ActiveRecord::Base.sanitize_sql_like(query)}%"
  end
end
