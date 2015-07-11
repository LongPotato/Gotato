class AddUserRefToCustomers < ActiveRecord::Migration
  def change
    add_reference :customers, :user, index: true
    add_foreign_key :customers, :users
  end
end
