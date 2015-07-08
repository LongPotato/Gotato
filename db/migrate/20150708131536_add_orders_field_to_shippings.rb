class AddOrdersFieldToShippings < ActiveRecord::Migration
  def change
    add_column :shippings, :order_fields, :text
  end
end
