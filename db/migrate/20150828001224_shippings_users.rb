class ShippingsUsers < ActiveRecord::Migration
  def change
    create_table :shippings_users, :id => false do |t|
      t.integer :shipping_id
      t.integer :user_id
    end
  end
end
