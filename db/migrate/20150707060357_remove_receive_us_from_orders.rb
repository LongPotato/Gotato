class RemoveReceiveUsFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :receive_us, :date
  end
end
