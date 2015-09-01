class Store < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user ? controller.current_user : nil }

  has_and_belongs_to_many :users
  has_many :orders

  before_save { self.name = name.try(:downcase).try(:strip) }

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
      where('name LIKE ?', "%#{search.downcase}%")
    else
      all
    end
  end
end
