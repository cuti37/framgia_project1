class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @post = current_user.posts.build
      @feed_items = current_user.feed.select(:id, :title, :body, :picture, :user_id,
        :created_at).sort_by_created_at.paginate page: params[:page],
        per_page: Settings.post.posts_per_page
    else
      @feed_items = Post.select(:id, :title, :body, :picture, :user_id,
        :created_at).sort_by_created_at.paginate page: params[:page],
        per_page: Settings.post.posts_per_page
    end
  end
end
