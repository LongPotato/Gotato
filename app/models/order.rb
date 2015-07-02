class Order < ActiveRecord::Base
  belongs_to :user
  
  validates :name, presence: true
  validates :user, presence: true

end
