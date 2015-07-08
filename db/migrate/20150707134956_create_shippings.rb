class CreateShippings < ActiveRecord::Migration
  def change
    create_table :shippings do |t|
      t.decimal :price
      t.date :ship_date
      t.text :description

      t.timestamps null: false
    end
  end
end
