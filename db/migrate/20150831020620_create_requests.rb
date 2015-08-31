class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.text :url
      t.text :note
      t.boolean :check

      t.timestamps null: false
    end
  end
end
