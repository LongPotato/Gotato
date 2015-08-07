class Datum < ActiveRecord::Base
  belongs_to :user
  has_many :orders

  def subtract_deleted_order
    self.order_sold -= 1
    self.save!
  end

end