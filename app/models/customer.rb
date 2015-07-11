class Customer < ActiveRecord::Base
  belongs_to :user
  has_many :orders
  has_many :shipping, through: :orders

  before_save { self.name = name.downcase.strip }
end
