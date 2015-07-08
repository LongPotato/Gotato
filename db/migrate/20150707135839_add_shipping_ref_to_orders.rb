class AddShippingRefToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :shipping, index: true
    add_foreign_key :orders, :shippings
  end
end
