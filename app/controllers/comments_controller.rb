class CommentsController < ApplicationController
  before_action :comment_params, only: [:new, :create, :update]
  before_action :find_post
  before_action :find_comment, only: [:create, :destroy]
  def create
      @comment = @post.comments.create comment_params
      @comment.user_id = current_user.id
      if @comment.save
        flash[:success] = t ".success_create_comment"
        respond_to do |format|
          format.html {redirect_to @post}
          format.js
        end
      else
        flash[:danger] = "Can't insert blank"
        respond_to do |format|
        format.html {redirect_to @post}
        format.js
        end
      end
  end

  def destroy
    if @comment.destroy
      respond_to do |format|
          format.html {redirect_to @post}
          format.js
      end
    else
      respond_to do |format|
        format.html {redirect_to @post}
        format.js
      end
    end
  end

  def load_more

  end
  private

  def comment_params
    params.require(:comment).permit :content
  end

  def find_post
    @post = Post.find params[:post_id]
  end

  def find_comment
    @comment = @post.comments.find_by id: params[:id]
  end

end
