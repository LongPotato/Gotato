class AddWebOrderIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :web_order_id, :string
  end
end
