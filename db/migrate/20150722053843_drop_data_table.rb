class DropDataTable < ActiveRecord::Migration
  def change
    drop_table :data
  end
end
