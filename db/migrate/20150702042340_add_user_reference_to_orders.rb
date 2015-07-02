class AddUserReferenceToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :user, index: true
    add_foreign_key :orders, :users
  end
end
