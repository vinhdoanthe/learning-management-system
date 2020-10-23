module User
  class SessionsController < ApplicationController

    skip_before_action :authenticate_user!, only: [:new, :create]

    def new

      session[:contest] = params[:contest]
      if logged_in?
        redirect_to root_path
      end
    end

    def create
      user = User::Account::User.find_by(username: params[:session][:username])

      if user.nil?
        flash.now[:danger] = 'Tên đăng nhập không tồn tại'
        render 'new'
      else

        if user.authenticate(params[:session][:password])
          log_in(user)
          if session[:contest].present? && session[:contest].to_i != 0
            redirect_to contest_new_project_path(id: session[:contest].to_i)
          else
            redirect_to root_path
          end
        else
          flash.now[:danger] = 'Mật khẩu không đúng'
          render 'new'
        end
      end
    end

    def destroy
      log_out
      redirect_to user_login_path
    end

    # def authenticate_user!
    #   redirect_to user_login_path unless logged_in?
    # end

    def new_parent_selection
      if children_account.count == 1
        log_in(children_account[0])
        redirect_to root_path
      end
    end

    def create_parent_selection
      child = User::Account::User.find(params[:child])
      log_in(child)
      redirect_to root_path
    end
  end
end
