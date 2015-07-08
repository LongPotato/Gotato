class Customer < ActiveRecord::Base
  has_many :orders
  has_many :shipping, through: :orders

  before_save { self.name = name.downcase }
end
