class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :active_relationships, class_name: Settings.user.relationship,
    foreign_key: Settings.user.foreign_key1, dependent: :destroy
  has_many :passive_relationships, class_name: Settings.user.relationship,
    foreign_key: Settings.user.foreign_key2, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

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

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  private

  def downcase_email
    self.email = email.downcase!
  end
end
