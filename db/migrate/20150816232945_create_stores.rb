class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.text :note
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :stores, :users
  end
end
