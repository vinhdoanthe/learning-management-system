class ApplicationController < ActionController::Base
  before_action :user_validated!
  helper_method :current_user


  def user_validated!

  end

  def current_user
    # if session[:user_id]
    #   @current_user ||= User.find(session[:user_id])
    # else
    #   @current_user = nil
    # end
  end

end
