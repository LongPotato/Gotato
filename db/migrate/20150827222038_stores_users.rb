class StoresUsers < ActiveRecord::Migration
  def change
    create_table :stores_users, :id => false do |t|
      t.integer :store_id
      t.integer :user_id
    end
  end
end
