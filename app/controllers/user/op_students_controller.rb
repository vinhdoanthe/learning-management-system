module User
  class OpStudentsController < ApplicationController
    before_action :authenticate_student!, :find_student, except: [:public_profile]
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!, only: [:public_profile]

    def dashboard

    end

    def index
      @op_students = OpStudent.all
    end

    def new

    end

    def public_profile
      if params[:op_student_id].present?
        @op_student = OpStudent.where(id: params[:op_student_id].to_i).first       
        if @op_student.nil?
          if !current_user.nil? and !current_user.student_id.nil?
            redirect_to user_public_profile_path(current_user.student_id)
          else
            redirect_to root_path
          end
        else

        end
      else 
        if !current_user.nil? and !current_user.student_id.nil?
          redirect_to user_public_profile_path(current_user.student_id)
        else
          redirect_to root_path
        end
      end
    end

    def student_info
      @batches = @student.op_batches
      @batch_states = OpStudentsService.batch_state @student
    end

    def student_homework
      data = OpStudentsService.student_homework params, @student
      @courses = @student.op_courses
      @session = data[:session]
      @batch = data[:batch]

      respond_to do |format|
        format.html
        format.js {render 'user/op_students/partials/table_homework_list', :locals => data}
      end
    end

    def student_product
      @products = SocialCommunity::ScProduct.where(student_id: @student.id).all
      @course_products = OpStudentsService.new.course_product 
    end

    def student_product_detail
      product = SocialCommunity::ScProduct.where(id: params[:product_id]).first
      batch = product.op_batch.name
      course = product.op_course.name
      student = product.op_student
      company = student.res_company ? student.res_company.name : ''

      respond_to do |format|
        format.js { render 'user/op_students/partials/student_product_detail', locals: { batch: batch, course: course, student: student.full_name, company: company, product: product } }
      end
    end

    def course_products
      @course = Learning::Course::OpCourse.where(id: params[:course_id]).first
      return nil if @course.blank?
      @products = SocialCommunity::ScProduct.where(course_id: @course.id).order(created_at: :DESC)
    end

    def student_redeem

    end

    def student_invoice

    end

    def student_timetable
      @sessions = @student.op_sessions

      @session = @sessions.where('start_datetime >= ?', Time.now).order(start_datetime: :ASC).first
      schedules = OpTeachersService.teaching_schedule(@sessions, params)

      if request.method == 'POST'
        render json: {schedules: schedules}
      end
    end

    def student_homework_detail

    end

    def student_videos_list
      data = OpStudentsService.student_homework params, @student
      @courses = @student.op_courses
      @session = data[:session]

      respond_to do |format|
        format.html
        format.js {render 'user/op_students/partials/student_videos_list', :locals => data}
      end
    end

    def student_video_subs

    end

    def refer_friend

    end

    def student_attendance_line
    end

    def session_evaluation
      op_session = nil
      op_faculty = nil
      op_batch = nil
      op_att_line = nil
      if params[:session_id].present?
        op_session = Learning::Batch::OpSession.find(params[:session_id].to_i)
        unless op_session.nil?
          op_batch = op_session.op_batch
          op_faculty = op_session.op_faculty
        end
        op_att_line = op_session.op_attendance_lines.where(student_id: @student.id).first
      end

      respond_to do |format|
        format.html
        format.js {render 'user/op_students/partials/session_evaluation', :locals => {op_faculty: op_faculty, op_batch: op_batch, op_session: op_session, op_att_line: op_att_line}}
      end
    end

    def student_attendance_content
      attendance = Learning::Batch::OpAttendanceLine.where(student_id: @student.id, session_id: params[:session_id]).first
      respond_to do |format|
        format.html
        format.js { render 'user/op_students/partials/student_evaluate_content', :locals => {attendance: attendance}}
      end
    end

    private

    def find_student
      @student = current_user.op_student
    end
  end

end
