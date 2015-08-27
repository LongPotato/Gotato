class OrdersUsers < ActiveRecord::Migration
  def change
    create_table :orders_users, :id => false do |t|
      t.integer :order_id
      t.integer :user_id
    end
  end
end
