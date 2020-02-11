module User
  class SessionsController < ApplicationController

    def new
    end

    # TODO: Update login by username (Not by email)
    def create
      user = User.find_by(email: params[:session][:email])
      if user && user.authenticate(params[:session][:password])
        log_in(user)
        redirect_to root_path
      else
        render 'new'
      end
    end

    def destroy
      log_out
      redirect_to user_login_path
    end

    def reset_password

    end

    def authenticate_user!
        redirect_to user_login_path unless logged_in?
    end

    def parent_selection

    end
  end
end
