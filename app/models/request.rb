class Request < ActiveRecord::Base
  include PublicActivity::Model
  tracked except: [:update], owner: Proc.new { |controller, model| controller.current_user ? controller.current_user : nil }
  
  has_and_belongs_to_many :users

  before_save { self.check = false if self.check.nil? }
end
