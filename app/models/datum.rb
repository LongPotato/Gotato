class Datum < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :orders

  def subtract_deleted_order
    self.order_sold -= 1
    self.save!
  end

end