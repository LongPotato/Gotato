class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :customer
  
  validates :name, presence: true
  validates :user, presence: true

end
