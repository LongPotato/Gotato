class MessagesUsers < ActiveRecord::Migration
  def change
    create_table :messages_users, :id => false do |t|
      t.integer :message_id
      t.integer :user_id
    end
  end
end
