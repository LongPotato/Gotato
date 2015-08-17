class AddStoreRefToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :store, index: true
    add_foreign_key :orders, :stores
  end
end
