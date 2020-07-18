class Adm::User::AdmUsersController < ApplicationController
  before_action :check_role
  skip_before_action :verify_authenticity_token

  def index
  end

  def filter_users
    service = Adm::User::AdmUsersService.new
    users = service.user_index params
    page = params[:page].to_i

    respond_to do |format|
      format.html
      format.js { render "/adm/user/adm_users/index", locals: { users: users, page: page }}
    end
  end

  def search_users
    all_user = Adm::User::AdmUsersService.new.all_user

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
    elsif user.account_role == 'Admin'
      @info = service.admin_info user
    end
  end

  def edit_user_info
    @user = User::Account::User.where(id: params[:id]).first
  end

  def update_user_info
    user = User::Account::User.where(id: params[:user_id]).first
    if user.blank?
      render json: { type: 'danger', message: 'Đã có lỗi xảy ra! Thử lại sau!' }
    else
      exist_user = User::Account::User.where(username: params[:username]).first
      if exist_user.present?
        render json: { type: 'danger', message: 'Tên đăng nhập đã tồn tại! Thử lại tên khác' }
      else
        user.username = params[:username]
        user.password = params[:password] if params[:password].present?
        if params[:avatar].present?
          #TODO create avatar
        end
        if user.save
          render json: { type: 'success', message: 'Cập nhật thành công' }
        else 
          render json: { type: 'danger', message: 'Đã có lỗi xảy ra! Thử lại sau!' }
        end
      end
    end
  end

  private

  def check_role
    if current_user.account_role != 'Admin'
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
