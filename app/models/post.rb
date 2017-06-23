class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  default_scope -> {order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :title, presence: true, length: {maximum: Settings.micropost.max_length_title}
  validates :body, presence: true, length: {maximum: Settings.micropost.max_length_body}
  scope :sort_by_created_at, ->{order created_at: :desc}
  scope :feed_load, lambda{|x,y|
    where("user_id IN (?) OR user_id = ?", x, y)}
end
