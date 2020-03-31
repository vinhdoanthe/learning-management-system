module User

  class OpStudentsController < ApplicationController

    before_action :authenticate_student!, :find_student
    skip_before_action :verify_authenticity_token

    def dashboard
      
    end

    def index
      @op_students = OpStudent.all
    end

    def new

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
      data = OpStudentsService.student_homework params, @student
      @course = data[:course]
      @batch = data[:batch]
      @products = SocialCommunity::ScProduct.where(student_id: @student.id, batch_id: @batch.id)
      @courses = @student.op_courses

      respond_to do |format|
        format.html
        format.js { render 'user/op_students/partials/student_product', locals: {batch: @batch, course: @course, products: @products, batches: data[:batches], subjects: data[:subjects], subject: data[:subject]} }
      end
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

    def student_redeem

    end

    def student_invoice

    end

    def student_timetable
    #  batches = @student.op_batches
      @sessions = @student.op_sessions

			# student_subject_ids = Learning::Course::OpSubject.joins(op_student_courses: :op_student).where(op_student: {id: @student.id}).pluck(:id)
     # student_subject_ids = @student.op_sessions.pluck(:subject_id).uniq
    #  binding.pry
      
		# 	batches.each do |batch|
		# 		@sessions << batch.op_sessions.where(subject_id: student_subject_ids)
		# 		#@sessions << batch.op_sessions
    #     session << batch.op_sessions.where('start_datetime >= ?', Time.now).order(start_datetime: :ASC).last
    #   end
    # 
			@session = @sessions.where('start_datetime >= ?', Time.now).order(start_datetime: :ASC).first
      # session.each{|s| @session = s if s.present? && @session.start_datetime <= s.start_datetime}
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
