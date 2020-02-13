class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper

  # before_action :authenticate_user!

  # Validated user!
  def authenticate_user!
    if logged_in?
      # redirect_to root_path
    else
      p 'something'
      redirect_to user_login_path
    end
  end

  def authenticate_student!
    if current_user.is_student?

    else
      redirect_to root_path
    end
  end

  def authenticate_faculty!
    if current_user.is_teacher?

    else
      redirect_to root_path
    end
  end
end
