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
      
      respond_to do |format|
        format.html
        format.js {render 'user/op_students/partials/table_homework_list', :locals => data}
      end
    end

    def student_product

    end

    def student_redeem

    end

    def student_invoice

    end

    def student_timetable
      batches = @student.op_batches
      @sessions = []
      session = []

      batches.each do |batch|
        @sessions << batch.op_sessions
        session << batch.op_sessions.where('start_datetime >= ?', Time.now).order(start_datetime: :ASC).last
      end

      @session = @student.op_sessions.where('start_datetime >= ?', Time.now).order(start_datetime: :DESC).first
      session.each{|s| @session = s if s.present? && @session.start_datetime <= s.start_datetime}
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
