class User::Account::UsersController < ApplicationController

  before_action :authenticate_user!, only: [:get_avatar, :new_avatar, :update_avatar, :update_nickname, :change_password, :update_password, :update_user_avatar]
  skip_before_action :verify_authenticity_token, only: :update_user_avatar
  # before_action :authenticate_student!, only: [:my_class, :batch_detail, :update_nickname]

  def get_avatar
    if params[:user_id].present?
      user = User::Account::User.where(id: params[:user_id].to_i).first
    else
      user = current_user
    end
    avatar_obj = user.get_avatar
    if avatar_obj.nil?
      nil
    else
      avatar_link = {
        'thumbnail' => url_for(avatar_obj[:thumbnail]),
        'full_size' => url_for(avatar_obj[:full_size])
      }
    end
    respond_to do |format|
      format.js {render 'user/op_students/modals/set_active_avatar', :partials => {avatar: avatar_link}}
    end
  end

  def new_avatar
    current_avatar = nil 
    if params[:user_id].present?
      user = User::Account::User.where(id: params[:user_id].to_i).first
    else
      user = current_user
    end
    avatar_obj = user.get_avatar
    unless avatar_obj.nil?
      current_avatar = {
        'id' => avatar_obj['id'],
        'thumbnail' => url_for(avatar_obj['thumbnail']),
        'full_size' => url_for(avatar_obj['full_size'])
      }
    end

    avatars = User::Account::Avatar.get_avatars_by_gender(user.gender)
    list_avatars = []
    avatars.each do |avatar|
      avatar_obj = {
        'id' => avatar.id,
        'thumbnail' => (avatar.thumbnail.attached? ? url_for(avatar.thumbnail) : ''),
        'full_size' => (avatar.full_size.attached? ? url_for(avatar.full_size) : '')
      }
      list_avatars << avatar_obj
    end 

    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/op_students/modal/change_avatar', :locals => {avatars: list_avatars, current_avatar: current_avatar}}
    end
  end

  def update_avatar
    if params[:avatar_id].present?
      if current_user.avatar_id != params[:avatar_id].to_i
        current_user.avatar_id = params[:avatar_id].to_i
        current_user.save!
        respond_to do |format|
          format.js {render 'user/open_educat/op_students/js/update_avatar', :locals => {avatar: current_user.avatar}}
        end
      end
    end
  end

  def update_user_avatar
    result = User::Account::UsersService.new.update_user_avatar current_user, params[:avatar]

    render json: result
  end

  def update_nickname
    new_username = params[:user][:username]

    if new_username =~ /\A[a-z0-9_]{4,16}\z/
      user = User::Account::User.find_by(username: new_username)
      if user.nil?
        current_user.username = new_username
        current_user.save
        if current_user.errors.full_messages.any?
          flash[:danger] = current_user.errors.full_messages.to_s
        else
          flash[:success] = 'C???p nh???t nickname th??nh c??ng'
        end
      else
        flash[:danger] = 'Nickname ???? t???n t???i'
      end
    else
      flash[:danger] = 'Nickname kh??ng ph?? h???p! Nick name ch??? ch???a c??c k?? t??? ch???, s??? v?? d???u g???ch d?????i(_)'
    end

    redirect_to user_open_educat_op_students_information_path
  end

  def change_password
  end

  def update_password
    if !params[:user][:password].nil?
      if current_user.authenticate(params[:user][:password])
        if !(params[:user][:new_password].nil? || params[:user][:password_confirmation].nil?)
          if params[:user][:new_password] == params[:user][:password_confirmation]
            current_user.update(password: params[:user][:new_password])
            if current_user.errors.full_messages.any?
              flash.now[:danger] = current_user.errors.full_message.to_s
              render 'change_password'
            else
              flash[:success] = '?????i m???t kh???u th??nh c??ng'
              redirect_to root_path
            end
          else
            flash.now[:danger] = 'M???t kh???u m???i kh??ng kh???p'
            render 'change_password'
          end
        else
          flash.now[:danger] = 'M???t kh???u hi???n t???i kh??ng ????ng'
          render 'change_password'
        end
      else
        flash.now[:danger] = 'M???t kh???u kh??ng ????ng'
        render 'change_password'
      end
    else
      flash.now[:danger] = '???? c?? l???i x???y ra. Vui l??ng th??? l???i'
      render 'change_password'
    end
  end

  def map_student_new_user students
    missing_email_students = []

    count_student = students.length()
    count = 0
    students.each do |student|
      count += 1
      puts "#{count}/#{count_student}"
      user = User::Account::UsersService.new.create_student_user student
      missing_email_students << user[:missing_email_student]
    end

    missing_email_students.compact!
    attributes = ['STT', 'ID', 'Full_name', 'Code']
    csv_file = CSV.generate(headers: true) do |csv|
      csv << attributes
      missing_email_students.each do |row|
        csv << row
      end
    end
    File.open("data_export/list_missing_parent_email_students.xlsx", "w+") do |f|
      f.write(csv_file.force_encoding('iso-8859-1').encode('utf-8').encode('iso-8859-1').force_encoding('utf-8'))
    end
  end

  def map_faculty_create_user faculty
    User::Account::UsersService.new.create_teacher_user faculty
  end
end
