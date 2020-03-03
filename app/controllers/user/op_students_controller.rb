module User

  class OpStudentsController < ApplicationController

    before_action :authenticate_student!, :find_student
    skip_before_action :verify_authenticity_token

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

    def student_videos

    end

    def student_video_subs

    end

    def refer_friend

    end

    def student_attendance_line
    end

    private

    def find_student
      @student = current_user.op_student
    end
  end

end
