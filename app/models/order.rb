class Order < ActiveRecord::Base
  attr_accessor :use_user_rate
  
  belongs_to :shipping
  belongs_to :user
  belongs_to :customer
  accepts_nested_attributes_for :customer, reject_if: lambda {|attributes| attributes[:name].blank?}
  
  validates :user, presence: true

  before_save :set_default

  #get next available order
  def next
    order = self.class.where("id > ?", id).first
    if order
      order
    else
      self.class.first
    end
  end

  #get previous order
  def prev
    order = self.class.where("id < ?", id).first
    if order
      order
    else
      self.class.last
    end
  end

  def calculate_total
    self.web_price.to_f + self.tax.to_f + self.shipping_us.to_f - self.reward.to_f
  end

  def calculate_total_cost
    (self.total.to_f + self.shipping_vn.to_f) * self.vnd.to_f
  end

  def calculate_profit
    self.selling_price.to_f - self.total_cost.to_f
  end

  def calculate_remain
    self.selling_price - self.deposit
  end

  private

    def set_default
      self.received_us = false if self.received_us.nil?
      self.web_price = 0 if self.web_price.nil?
      self.tax = 0 if self.tax.nil?
      self.reward = 0 if self.reward.nil?
      self.shipping_us = 0 if self.shipping_us.nil?
      self.shipping_vn = 0 if self.shipping_vn.nil?
      self.vnd = 21000 if self.vnd.nil?
      self.total= 0 if self.total.nil?
      self.total_cost = 0 if self.total_cost.nil?
      self.profit = 0 if self.profit.nil?
      self.selling_price = 0 if self.selling_price.nil?
      self.deposit = 0 if self.deposit.nil?
      self.remain = 0 if self.remain.nil?
    end

end
