class Message < ActiveRecord::Base
  belongs_to :sender, :foreign_key => :sender_id, class_name: "User"
  belongs_to :recipient, :foreign_key => :recipient_id, class_name: "User"
  has_and_belongs_to_many :users
  belongs_to :user

  validates_presence_of :body
end