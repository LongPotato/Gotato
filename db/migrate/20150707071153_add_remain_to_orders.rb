class AddRemainToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :remain, :decimal
  end
end
