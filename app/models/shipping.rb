class Shipping < ActiveRecord::Base
  has_many :users
  has_many :orders
  has_many :customers, through: :orders

  validates :price, presence: true
  validates :ship_date, presence: true
  validates :order_fields, presence: true

end
