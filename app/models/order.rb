class Order < ActiveRecord::Base
  attr_accessor :use_user_rate, :customer_name

  belongs_to :user
  belongs_to :customer
  
  validates :name, presence: true
  validates :user, presence: true

  before_save :set_default
  before_save { self.name = name.downcase }

  #get next available order
  def next
    self.class.where("id > ?", id).first
  end

  private

    def set_default
      self.quantity = 1 if self.quantity.nil?
      self.web_price = 0 if self.web_price.nil?
      self.tax = 0 if self.tax.nil?
      self.reward = 0 if self.reward.nil?
      self.shipping_us = 0 if self.shipping_us.nil?
      self.shipping_vn = 0 if self.shipping_vn.nil?
      self.vnd = 21000 if self.vnd.nil?
      self.total= 0 if self.total.nil?
      self.total_cost = 0 if self.total_cost.nil?
      self.profit = 1 if self.profit.nil?
      self.deposit = 1 if self.deposit.nil?
      self.selling_price = 1 if self.selling_price.nil?
    end

end
