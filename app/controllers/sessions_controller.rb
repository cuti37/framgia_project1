class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      flash[:info] = t ".success_login"
      log_in user
      if params[:session][:remember_me] == Settings.sessions.create.remember
        remember user
      else
        forget user
      end
      redirect_back_or user
    else
      flash.now[:danger] = t ".error_login"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
