module User
  class SessionsController < ApplicationController

    def new
    end

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
      redirect_to root_url
    end

    def reset_password

    end
  end
end
