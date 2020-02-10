class User::SessionsController < ApplicationController

  def new
  end

  def create
    # user = User.find_by(username :params[:session][:email].downcase)
    # if user && user.authenticate(params[:session][:password])
    #   redirect_to
    # else
    #   render 'new'
    # end
  end

  def destroy

  end

  def reset_password

  end
end
