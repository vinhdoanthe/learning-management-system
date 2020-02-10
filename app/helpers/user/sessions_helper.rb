module User

  module SessionsHelper
    # Logs in the given user.
    def log_in(user)
      session[:user_id] = user.id
    end

    # Get current logged_in user
    def current_user
      if session[:user_id]
        @current_user ||= User.find(session[:user_id])
      else
        @current_user = nil
      end
    end

    def log_out
      session.delete(:user_id)
      @current_user = nil
    end
  end
end
