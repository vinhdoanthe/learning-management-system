module User
  module SessionsHelper
    
    # Logs in the given user.
    def log_in(user)
      session[:user_id] = user.id
    end

    def logged_in?
      !current_user.nil?
    end

    # Get current logged_in user
    def current_user
      if session[:user_id]
        @current_user ||= User::Account::User.find(session[:user_id])
      else
        @current_user = nil
      end
    end

    def log_out
      session.delete(:user_id)
      @current_user = nil
    end

    def children_account
      if current_user.account_role == Constant::PARENT
        @children_account = User::Account::User.where(:parent_account_id => current_user.id)
      end
    end
  end
end
