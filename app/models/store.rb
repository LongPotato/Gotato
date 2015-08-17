class Store < ActiveRecord::Base
  belongs_to :user
  has_many :orders

  before_save { self.name = name.downcase.strip }

  #get next available order
  def next(user_id)
    order = self.class.where(["id > ? and user_id = ?", id, user_id]).first
    if order
      order
    else
      self.class.first
    end
  end

  #get previous order
  def prev(user_id)
    order = self.class.where(["id < ? and user_id = ?", id, user_id]).first
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
