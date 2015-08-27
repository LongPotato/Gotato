class FixColumnNameFromUsers < ActiveRecord::Migration
  def change
    rename_column :users, :manger_id, :manager_id
  end
end
