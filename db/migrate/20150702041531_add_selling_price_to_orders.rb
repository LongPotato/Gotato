class AddSellingPriceToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :selling_price, :decimal
  end
end
