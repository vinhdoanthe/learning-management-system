class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include User::SessionsHelper

  # before_action :authenticate_user!


  # Validated user!
  def authenticate_user!
    if current_user.nil?
      redirect_to root_path
    end
  end
end
