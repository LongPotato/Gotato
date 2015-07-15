class AddBankToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :bank, :text
  end
end
