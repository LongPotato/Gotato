class RequestsUsers < ActiveRecord::Migration
  def change
    create_table :requests_users, :id => false do |t|
      t.integer :request_id
      t.integer :user_id
    end
  end
end
