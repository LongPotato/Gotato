class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name
      t.integer :quantity
      t.text :description
      t.text :note
      t.string :store
      t.string :image_link

      t.date :order_date
      t.date :receive_us
      t.date :ship_vn

      t.decimal :web_price
      t.decimal :tax
      t.decimal :shipping_us
      t.decimal :reward
      t.decimal :shipping_vn
      
      t.decimal :total
      t.decimal :total_cost

      t.decimal :vnd
      t.decimal :profit
      t.decimal :deposit
      
      t.timestamps null: false
    end
  end
end
