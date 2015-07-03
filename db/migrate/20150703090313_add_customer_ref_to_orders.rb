class AddCustomerRefToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :customer, index: true
    add_foreign_key :orders, :customers
  end
end
