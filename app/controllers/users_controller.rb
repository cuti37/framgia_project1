class UsersController < ApplicationController
  before_action :load_user, only: :show
  before_action :load_user, only: :show

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
    @posts = @user.posts.paginate page: params[:page],
      per_page: Settings.micropost.micropost_per_page
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
