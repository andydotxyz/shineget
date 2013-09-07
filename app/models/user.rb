class User < ActiveRecord::Base
  has_many :lists
  before_save { self.email = email.downcase }

  validates :username, presence: true
  has_secure_password
  validates :password, length: { minimum: 6 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
            format:     { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  after_create :add_default_list

  protected
    def add_default_list
      lists.create(name:"Default Wishlist")
      save
    end
end
