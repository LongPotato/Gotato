class Order < ActiveRecord::Base
  attr_accessor :use_user_rate

  belongs_to :user
  belongs_to :customer
  
  validates :name, presence: true
  validates :user, presence: true

  #get next available order
  def next
    self.class.where("id > ?", id).first
  end

end
