class RemoveStoreFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :store, :string
  end
end
