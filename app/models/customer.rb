class Customer < ActiveRecord::Base
  has_many :orders

  before_save { self.name = name.downcase }
end
