class Order < ActiveRecord::Base
  attr_accessor :use_user_rate
  
  mount_uploader :image_link, PictureUploader

  belongs_to :shipping
  belongs_to :user
  belongs_to :customer
  accepts_nested_attributes_for :customer, reject_if: lambda {|attributes| attributes[:name].blank?}
  
  validates :user, presence: true
  validate  :picture_size

  before_save :set_default

  #get next available customer
  def next
    customer = self.class.where("id > ?", id).first
    if customer
      customer
    else
      self.class.first
    end
  end

  #get previous customer
  def prev
    customer = self.class.where("id < ?", id).first
    if customer
      customer
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

    # Validates the size of an uploaded picture.
    def picture_size
      if image_link.size > 5.megabytes
        errors.add(:image_link, "should be less than 5MB")
      end
    end

end
