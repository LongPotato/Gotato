class AddManagerIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :manger_id, :integer
  end
end
