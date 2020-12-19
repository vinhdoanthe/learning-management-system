class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  around_action :switch_locale
  include ApplicationHelper

  before_action :authenticate_user!, :set_raven_context
  ERROR_TURTLE = 'layouts/errors/turtle' 

  # Validated user!
  def authenticate_user!
    unless logged_in? || ((request.original_fullpath.include? 'contest') && (request.original_fullpath.include? 'home'))
      redirect_to user_login_path(next_page: params[:next_page])
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

  private

  def switch_locale(&action)
    locale = current_language || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def current_language
    if params[:locale].present?
      session[:current_language] = params[:locale]
    end

    session[:current_language]
  end

  def set_raven_context
    Raven.user_context(id: session[:current_user_id]) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
