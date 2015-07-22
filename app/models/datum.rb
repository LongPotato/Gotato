class Datum < ActiveRecord::Base
  belongs_to :user
  has_many :orders
end
