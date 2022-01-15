class CreateConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations do |t|
      t.timestamps
    end

    create_table :conversations_users, id: false do |t|
      t.belongs_to :conversation
      t.belongs_to :user
    end
  end
end
