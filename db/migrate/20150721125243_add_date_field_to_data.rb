class AddDateFieldToData < ActiveRecord::Migration
  def change
    add_column :data, :month_record, :date
  end
end
