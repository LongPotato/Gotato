class CreateData < ActiveRecord::Migration
  def change
    create_table :data do |t|
      t.decimal :total_cost
      t.decimal :total_selling
      t.decimal :revenue
      t.integer :order_sold

      t.timestamps null: false
    end
  end
end
