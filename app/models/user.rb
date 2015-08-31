class User < ActiveRecord::Base
  attr_accessor :remember_token, :reset_token

  #Attributes validations:
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  has_secure_password

  has_one :seller, class_name: "User", foreign_key: :manager_id
  belongs_to :manager, class_name: "User", foreign_key: :manager_id

  scope :manager, -> { where('role == ?', 'manager') }

  #Callback:
  before_save { self.email = email.downcase }
  before_save { self.setting_vnd = 21000 if self.setting_vnd.nil? }

  ROLES = %w[manager seller]

  #Relation:
  has_and_belongs_to_many :orders
  has_and_belongs_to_many :stores
  has_and_belongs_to_many :customers
  has_and_belongs_to_many :shippings
  has_and_belongs_to_many :data
  has_and_belongs_to_many :requests

  #Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  #Returns the hash digest of the given string.
  def User.encrypt_token(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.encrypt_token(reset_token))
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  #Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.encrypt_token(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  def clear_reset_digest
    update_attribute(:reset_digest, nil)
  end

  def User.update_rate
    User.all.each {|user| user.update_vnd }
  end

  def update_vnd
    self.setting_vnd = GoogCurrency.usd_to_vnd(1)
    self.save!
  end

end
