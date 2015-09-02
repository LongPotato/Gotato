class DropConversations < ActiveRecord::Migration
  def change
    drop_table :conversations
  end
end
