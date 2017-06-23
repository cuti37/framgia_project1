class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  default_scope -> {order(created_at: :asc)}
  validates :content, presence: true, length: {maximum: Settings.micropost.max_length_body}
  scope :feed_load_comment, ->id{where "user_id = ?", id}
end
