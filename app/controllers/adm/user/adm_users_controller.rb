class Adm::User::AdmUsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    student_users = User::Account::User.where(account_role: 'Student').joins(op_student: :res_company).pluck(:id, :username, :email, :account_role, 'op_student.full_name', :created_at, :last_sign_in_at, :last_sign_out_at, 'res_company.name')
    teacher_users = User::Account::User.where(account_role: 'Teacher').joins(op_faculty: :res_company).pluck(:id, :username, :email, :account_role, 'op_faculty.full_name', :created_at, :last_sign_in_at, :last_sign_out_at, 'res_company.name')
    parent_users = User::Account::User.where(account_role: 'Parent').joins(op_parent: { res_partner: :res_company }).pluck(:id, :username, :email, :account_role, 'res_partner.name', :created_at, :last_sign_in_at, :last_sign_out_at, 'res_company.name')
    admin_users = User::Account::User.where(account_role: 'Admin').joins(res_user: { res_partner: :res_company }).pluck(:id, :username, :email, :account_role, 'res_partner.name', :created_at, :last_sign_in_at, :last_sign_out_at, 'res_company.name')

    users = []
    users.concat(student_users, teacher_users, parent_users, admin_users)
    all_user = []

    users.each do |info|
      user = { id: info[0], username: info[1], email: info[2], account_role: info[3], full_name: info[4], created_at: info[5], last_sign_in_at: info[6], last_sign_out_at: info[7], company: info[8] }
      all_user << user
    end

    @all_user = all_user.sort_by { |user| user[:id] }
    @all_user = Kaminari.paginate_array(@all_user).page(params[:page]).per(30)
  end

  # def all_user
  #   student_users = User::Account::User.where(account_role: 'Student').joins(op_student: :res_company).pluck(:id, :username, :email, :account_role, 'op_student.full_name', :created_at, :last_sign_in_at, :last_sign_out_at, 'res_company.name')
  #   teacher_users = User::Account::User.where(account_role: 'Teacher').joins(op_faculty: :res_company).pluck(:id, :username, :email, :account_role, 'op_faculty.full_name', :created_at, :last_sign_in_at, :last_sign_out_at, 'res_company.name')
  #   parent_users = User::Account::User.where(account_role: 'Parent').joins(op_parent: { res_partner: :res_company }).pluck(:id, :username, :email, :account_role, 'res_partner.name', :created_at, :last_sign_in_at, :last_sign_out_at, 'res_company.name')
  #   admin_users = User::Account::User.where(account_role: 'Admin').joins(res_user: { res_partner: :res_company }).pluck(:id, :username, :email, :account_role, 'res_partner.name', :created_at, :last_sign_in_at, :last_sign_out_at, 'res_company.name')

  #   users = []
  #   users.concat(student_users, teacher_users, parent_users, admin_users)
  #   all_user = []

  #   users.each do |info|
  #     user = { id: info[0], username: info[1], email: info[2], account_role: info[3], full_name: info[4], created_at: info[5], last_sign_in_at: info[6], last_sign_out_at: info[7], company: info[8] }
  #     all_user << user
  #   end

  #   render json: { data: Kaminari.paginate_array(all_user).page(params[:page]).per(50) }
  # end

  def filter_users
  end

  def search_users

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
end
