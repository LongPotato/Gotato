class AddUserRefToShippings < ActiveRecord::Migration
  def change
    add_reference :shippings, :user, index: true
    add_foreign_key :shippings, :users
  end
end
