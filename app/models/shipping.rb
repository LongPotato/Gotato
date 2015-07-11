class Shipping < ActiveRecord::Base
  has_many :users
  has_many :orders
  has_many :customers, through: :orders

  validates :price, presence: true
  validates :ship_date, presence: true
  validates :order_fields, presence: true

  #get next available shipment
  def next
    shipment = self.class.where("id > ?", id).first
    if shipment
      shipment
    else
      self.class.first
    end
  end

  #get previous shipment
  def prev
    shipment = self.class.where("id < ?", id).first
    if shipment
      shipment
    else
      self.class.last
    end
  end

  def calculate_ship_vn
    self.price / Order.where(shipping_id: self.id).count
  end
  
end
