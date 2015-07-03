class AddSettingVndToUsers < ActiveRecord::Migration
  def change
    add_column :users, :setting_vnd, :decimal
  end
end
