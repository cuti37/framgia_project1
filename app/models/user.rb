class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.users.name.max_length}
  VALIDATE_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: Settings.users.email.max_length},
  format: {with: VALIDATE_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true,
    length: {minimum: Settings.users.password.min_length}, allow_nil: true

  class << self
    def digest string

      if ActiveModel::SecurePassword.min_cost
        cost = BCrypt::Engine::MIN_COST
      else
        cost = BCrypt::Engine.cost
      end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def is_current_user? current
    self == current
  end

  def feed
    Post.feed_load id
  end

  private

  def downcase_email
    self.email = email.downcase!
  end
end
