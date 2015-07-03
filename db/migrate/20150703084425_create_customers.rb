class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|

      t.timestamps null: false
    end
  end
end
