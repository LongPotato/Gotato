class Customer < ActiveRecord::Base
  include PublicActivity::Model
  #tracked except: :destroy, owner: Proc.new { |controller, model| controller.current_user ? controller.current_user : nil }

  belongs_to :user
  has_many :orders
  has_many :shipping, through: :orders

  before_save { self.name = name.downcase.strip }

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

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search.downcase}%")
    else
      all
    end
  end

end
