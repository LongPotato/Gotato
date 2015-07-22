class AddDataRefToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :datum, index: true
    add_foreign_key :orders, :data
  end
end
