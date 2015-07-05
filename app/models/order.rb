class Order < ActiveRecord::Base
  attr_accessor :use_user_rate

  belongs_to :user
  belongs_to :customer
  accepts_nested_attributes_for :customer, reject_if: lambda {|attributes| attributes[:name].blank?}
  
  validates :name, presence: true
  validates :user, presence: true

  before_save :set_default
  before_save { self.name = name.downcase }

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
    self.total.to_f + self.shipping_vn.to_f
  end

  def calculate_profit
    self.selling_price.to_f - (self.total_cost.to_f * self.vnd.to_f)
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
      self.profit = 0 if self.profit.nil?
      self.deposit = 0 if self.deposit.nil?
    end

end
