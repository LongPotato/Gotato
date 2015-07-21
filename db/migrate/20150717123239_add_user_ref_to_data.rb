class AddUserRefToData < ActiveRecord::Migration
  def change
    add_column :data, :user, :reference
  end
end