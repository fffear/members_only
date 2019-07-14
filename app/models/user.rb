class User < ApplicationRecord
  attr_accessor :remember_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+\.*[a-z\d\-]+\.[a-z]+\z/i
  before_save :downcase_email
  before_create :create_remember_digest

  validates :name,     presence:     true,
                       length:       { maximum: 50 }
  validates :email,    presence:     true,
                       uniqueness:   { case_sensitive: false },
                       length:       { maximum: 255 },
                       format:       { with: VALID_EMAIL_REGEX }
  has_secure_password
  validates :password, presence:     true,
                       length:       { minimum: 6 }   
             

  def self.digest_password(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns the hash digest of the given string.            
  def self.digest(string)
    Digest::SHA1.hexdigest(string)
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def change_remember_token_and_digest
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end


  private
    def downcase_email
      email.downcase!
    end

    def create_remember_digest
      self.remember_token = User.new_token
      self.remember_digest = User.digest(remember_token)
    end
end
