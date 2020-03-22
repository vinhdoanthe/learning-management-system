module User
  class UsersController < ApplicationController

    before_action :authenticate_user!, only: [:my_class, :batch_detail, :update_nickname, :update_password]
    before_action :authenticate_student!, only: [:my_class, :batch_detail, :update_nickname]

    def batch_detail
      if params[:batch_id].present?
        @batch = Learning::Batch::OpBatch.find(params[:batch_id])
      end
    end

    def my_class
      op_student = current_user.op_student
      if !op_student.nil?
        @batches = current_user.op_student.op_batches
      else
        @batches = []
      end 
    end

    def update_nickname
      unless params[:user][:username].nil?
        new_username = params[:user][:username]
        new_username.gsub!(/\s+/, ' ')
        if new_username.empty?
          flash.now[:danger] = 'Nickname không được phép để trống'
        else
          user = User.find_by(username: new_username)
          if user.nil?
            current_user.username = new_username
            current_user.save
            if current_user.errors.full_messages.any?
              flash.now[:danger] = current_user.errors.full_messages.to_s
            else
              flash[:success] = 'Cập nhật nickname thành công'
            end
          else
            flash.now[:danger] = 'Nickname đã tồn tại'
          end
        end
        redirect_to user_student_info_path
        # end
      end
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
                flash[:success] = 'Đổi mật khẩu thành công'
                redirect_to root_path
              end
            else
              flash.now[:danger] = 'Mật khẩu mới không khớp'
              render 'change_password'
            end
          else
            flash.now[:danger] = 'Mật khẩu hiện tại không đúng'
            render 'change_password'
          end
        else
          flash.now[:danger] = 'Mật khẩu không đúng'
          render 'change_password'
        end
      else
        flash.now[:danger] = 'Đã có lỗi xảy ra. Vui lòng thử lại'
        render 'change_password'
      end
    end

    def map_student_new_user students
      missing_email_students = []

      students.each do |student|
        user = UsersService.new.create_student_user student
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
      File.open("List_missing_parent_email_students.xlsx", "w+") do |f|
        f.write(csv_file.force_encoding('iso-8859-1').encode('utf-8').encode('iso-8859-1').force_encoding('utf-8'))
      end
    end

  end
end
