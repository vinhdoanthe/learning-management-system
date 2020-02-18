module User
  class UsersController < ApplicationController

    before_action :authenticate_student!, only: [:my_class, :batch_detail, :update_nickname, :update_password]

    def batch_detail
      @batch = Learning::Batch::OpBatch.find(params[:batch_id])
    end

    def my_class
      @batches = current_user.op_student.op_batches
    end

    # TODO: return general information of a student
    def general_information

      render :json => {}
    end


    # TODO: return parent information of a student
    def parent_information

      render :json => {}
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
        respond_to do |format|
          format.html { render :template => 'user/op_students/student_info' }
        end

        # render :html => 'user/op_students/student_info'
      end
    end

    def update_password
    end
  end
end
