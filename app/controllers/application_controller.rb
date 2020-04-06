class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper

  before_action :authenticate_user!
 ERROR_TURTLE = 'layouts/errors/turtle' 

  # Validated user!
  def authenticate_user!
    unless logged_in?
      redirect_to user_login_path
    end
  end

  def authenticate_student!
    unless current_user.is_student?
      redirect_to root_path
    end
  end

  def authenticate_faculty!
    unless current_user.is_teacher?
      flash[:danger] = 'Bạn không có quyền truy cập đến tài nguyên này'
      redirect_to root_path
    end
  end

  def authenticate_admin!
    unless current_user.is_admin?
      flash[:danger] = 'Bạn không có quyền truy cập đến tài nguyên này'
      redirect_to root_path
    end
  end

  def redirect_error_site(e)
    logger.error e.to_s
    puts e.to_s
    render :template => ERROR_TURTLE, :layout => false, :locals => { :msg => 'Có lỗi xảy ra rồi!' }
  end
end
