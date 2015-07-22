class AddUserReferencesToDataTable < ActiveRecord::Migration
  def change
    add_reference :data, :user, index: true
    add_foreign_key :data, :users
  end
end
