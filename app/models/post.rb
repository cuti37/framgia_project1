class Post < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :title, presence: true, length: {maximum: Settings.micropost.max_length_title}
  validates :body, presence: true, length: {maximum: Settings.micropost.max_length_body}
  scope :feed_load, ->id{where "user_id = ?", id}
end
