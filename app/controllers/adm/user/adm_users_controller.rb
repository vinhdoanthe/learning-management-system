class Adm::User::AdmUsersController < ApplicationController
  before_action :check_role
  skip_before_action :verify_authenticity_token

  @@filter_params = {}

  def index
    @allow_companies =  if current_user.is_operation_admin?
                        current_user.res_companies
                      else
                        Common::ResCompany.all
                      end
  end

  def new
  end

  def create
  end

  def filter_users
    service = Adm::User::AdmUsersService.new
    users = service.user_index params, current_user, @@filter_params

    @@filter_params = params if (@@filter_params.reject{ |k, _| (k == 'page' || k == 'count') } != params.reject{ |k, _| k == 'page' })
    @@filter_params['count'] = users[:count] if users[:count].present?
    page = params[:page].to_i

    respond_to do |format|
      format.html
      format.js { render "/adm/user/adm_users/index", locals: { users: users[:all_user], count: @@filter_params[:count], page: page }}
    end
  end

  def search_users
    Adm::User::AdmUsersService.new.all_user
  end

  def login_as_user
    user = User::Account::User.where(id: params[:user_id]).first

    if user.present?
      log_in(user)
      redirect_to root_path
    end
  end

  def user_info
    user = User::Account::User.where(id: params[:id]).first
    return if user.blank?

    service = Adm::User::AdmUsersService.new

    if user.account_role == 'Student'
      @info = service.student_info user
    elsif user.account_role == 'Teacher'
      @info = service.teacher_info user
    elsif user.account_role == 'Parent'
      @info = service.parent_info user
    else
      @info = service.admin_info user
    end
  end

  def edit_user_info
    @user = User::Account::User.where(id: params[:id]).first
    @user_companies = @user.user_companies
    @companies = Common::ResCompany.all
    @available_roles = User::Account::User.pluck(:account_role).uniq
  end

  def update_user_info
    result = Adm::User::AdmUsersService.new.update_user_info params

    render json: result
  end

  def update_user_password
    result = Adm::User::AdmUsersService.new.update_password params

    render json: result
  end

  def new_user
    @companies = Common::ResCompany.pluck(:id, :name)
    @available_roles = [Constant::OPERATION_ADMIN]
  end

  def create_user
    result = Adm::User::AdmUsersService.new.create_user params

    render json: result
  end

  private

  def check_role
    allow_roles = [Constant::ADMIN, Constant::OPERATION_ADMIN]
    unless allow_roles.include? current_user.account_role
      if request.method != 'POST'
        flash[:danger] = "Bạn không có quyền truy cập đến tài nguyên này"
        redirect_to root_path   
      else
        flash[:danger] = "Bạn không có quyền truy cập đến tài nguyên này"
        render :js => "window.location = '/'"
      end
    end
  end
end
