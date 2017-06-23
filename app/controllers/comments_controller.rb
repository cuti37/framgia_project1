class CommentsController < ApplicationController
  before_action :comment_params, only: [:new, :create, :update]
  before_action :find_post
  before_action :find_comment, only: [:create, :destroy]
  def create
      @comment = @post.comments.create comment_params
      @comment.user_id = current_user.id

      if @comment.save
        flash[:success] = t ".success_create_comment"
        redirect_to @post
      else
        flash[:danger] = "Can't insert blank"
        redirect_to @post
      end
  end

  private

  def comment_params
    params.require(:comment).permit :content
  end

  def find_post
    @post = Post.find params[:post_id]
  end

  def find_comment
    @comment = @post.comments.find_by params[:id]
  end

end
