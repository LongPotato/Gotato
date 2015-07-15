class AddAddressToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :address, :text
  end
end
