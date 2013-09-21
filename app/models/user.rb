class User < ActiveRecord::Base
  has_many :lists
  before_save { self.email = email.downcase }

  validates :username, presence: true, 
            uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, length: { minimum: 6 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
            format:     { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  after_create :add_default_list

  def to_param
    username
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  protected
    def add_default_list
      lists.create(name:"Default Wishlist")
      save
    end

  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
