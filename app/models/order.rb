class Order < ActiveRecord::Base
  include PublicActivity::Model
  tracked except: [:update], owner: Proc.new { |controller, model| controller.current_user ? controller.current_user : nil }

  attr_accessor :use_user_rate
  
  mount_uploader :image_link, PictureUploader

  belongs_to :shipping
  has_and_belongs_to_many :users
  belongs_to :customer
  belongs_to :store
  belongs_to :datum
  accepts_nested_attributes_for :customer #reject_if: lambda {|attributes| attributes[:name].blank?}
  accepts_nested_attributes_for :store

  scope :sale, -> { joins(:customer).where('customers.name = ?', 'for sale') }
  scope :placed, -> { joins(:customer).where('customers.name != ?', 'for sale') }
  scope :this_month, -> { where("order_date >= ?", Time.now.beginning_of_month) }
  scope :three_months, -> { where("order_date BETWEEN ? AND ?", 3.months.ago.beginning_of_month, Time.now.beginning_of_month) }
  scope :received, -> { where('received_us = ?', true) }
  scope :not, -> { where('received_us != ?', true) }
  scope :remaining, -> { where('shipping_id' => nil) }
  
  #validates :user, presence: true
  validate  :picture_size

  before_save :set_default
  before_save { self.description = description.downcase.strip }
  before_save { self.web_order_id = web_order_id.strip }

  #get next available order
  def next
    order = self.class.includes(:users).where("id > ?", id).first
    if order
      order
    else
      self.class.first
    end
  end

  #get previous order
  def prev
    order = self.class.includes(:users).where("id < ?", id).first
    if order
      order
    else
      self.class.last
    end
  end

  def self.search(search)
    if search
      where('description LIKE ?', "%#{search}%")
    else
      all
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
      self.order_date = Time.now if self.order_date.nil?
      self.web_price = 0 if self.web_price.nil?
      self.tax = 0 if self.tax.nil?
      self.reward = 0 if self.reward.nil?
      self.shipping_us = 0 if self.shipping_us.nil?
      self.shipping_vn = 0 if self.shipping_vn.nil?
      self.vnd = 21000 if self.vnd.nil?
      self.total = 0 if self.total.nil?
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
