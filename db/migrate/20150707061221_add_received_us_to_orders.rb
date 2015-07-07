class AddReceivedUsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :received_us, :boolean
  end
end
