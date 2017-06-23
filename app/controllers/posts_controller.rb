class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  before_action :load_post, only: [:show, :create, :destroy]

  def show
    @comments = @post.comments
  end

  def create
    @post = current_user.posts.build post_params
    if @post.save
      @feed_items = current_user.feed.select(:id, :title, :body, :picture, :user_id,
        :created_at).sort_by_created_at.paginate page: params[:page],
        per_page: Settings.post.posts_per_page
      flash[:success] = t ".success_create_micropost"
      redirect_to current_user
    else
      @feed_items = current_user.feed.select(:id, :title, :body, :picture, :user_id,
        :created_at).sort_by_created_at.paginate page: params[:page],
        per_page: Settings.post.posts_per_page
      render "static_pages/home"
    end
  end

  def destroy
    if @post.destroy
      flash[:success] = t ".micropost_delete"
    else
      flash.now[:alert] = t ".failed_delete"
    end
    redirect_to current_user
  end

  private

  def post_params
    params.require(:post).permit :title, :body, :picture
  end

  def correct_user
    @post = current_user.posts.find_by id: params[:id]
    redirect_to root_url if @post.nil?
  end

  def load_post
    @post = Post.find_by id: params[:id]
  end
end
