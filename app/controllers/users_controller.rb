class UsersController < ApplicationController
  before_action :load_user, only: [:show, :following, :followers]

  def index
    @users = User.select(:id, :name, :email).activated.order(:id)
      .paginate page: params[:page], per_page: Settings.user.user_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t ".check_email"
      redirect_to root_url
    else
      flash.now[:danger] = t ".error"
      render :new
    end
  end

  def show
    if logged_in?
      @post = current_user.posts.build
    end
    @posts = @user.posts.paginate page: params[:page],
      per_page: Settings.micropost.micropost_per_page
  end

  def following
    @title = "Following"
    @users = @user.following.paginate page: params[:page],
      per_page: Settings.micropost.micropost_per_page
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @users = @user.followers.paginate page: params[:page],
      per_page: Settings.micropost.micropost_per_page
    render "show_follow"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end

  def load_user
    @user = User.find_by id: params[:id]

    if @user.nil?
      flash[:warning] = t ".not_found"
      redirect_to root_path
    end
  end
end
