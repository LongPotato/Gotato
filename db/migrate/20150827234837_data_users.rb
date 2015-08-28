class DataUsers < ActiveRecord::Migration
  def change
    create_table :data_users, :id => false do |t|
      t.integer :datum_id
      t.integer :user_id
    end
  end
end
