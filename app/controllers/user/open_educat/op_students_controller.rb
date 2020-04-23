module User
  module OpenEducat
    class OpStudentsController < ApplicationController
      before_action :authenticate_student!, except: [:public_profile, :session_student, :student_evaluate, :timetable]
      before_action :get_op_student, except: [:public_profile, :session_student, :student_evaluate]
      skip_before_action :verify_authenticity_token, only: [:timetable]

      def dashboard

      end

      def index
        @op_students = OpStudent.all
      end

      def new

      end

      def information
        @batches = @op_student.op_batches
        @batch_states = OpenEducat::OpStudentsService.batch_state @op_student

      rescue StandardError => e
        redirect_error_site(e)
      end

      def batch_detail
        if params[:batch_id].present?
          batch, course_name, active_student_course, op_student_courses, faculty_names, batch_subjects, done_subjects, session_count, company_name, classroom_name = Learning::Batch::OpBatchService.get_batch_detail(params[:batch_id], @op_student.id)
          respond_to do |format|
            format.json
            format.js
            format.html {render 'batch_detail', :locals => {
              batch: batch,
              course_name: course_name, 
              active_student_course: active_student_course,
              op_student_courses: op_student_courses, 
              faculty_names: faculty_names, 
              batch_subjects: batch_subjects,
              done_subjects: done_subjects, 
              session_count: session_count, 
              company_name: company_name,
              classroom_name: classroom_name
            }
            }
          end
        end
      rescue StandardError => e
        redirect_error_site(e)
      end

      def batches
        op_student = current_user.op_student
        if !op_student.nil?
          @batches = current_user.op_student.op_batches
        else
          @batches = []
        end

      rescue StandardError => e
        redirect_error_site(e)
      end

      def batch_progress
        if params[:batch_id].present?
          batch, student_course, subjects, coming_soon_session, done_sessions, tobe_sessions, cancel_sessions = Learning::Batch::OpBatchService.get_student_batch_progress(params[:batch_id], @op_student.id)
          respond_to do |format|
            format.html
            format.js {render 'batch_progress', locals: {batch: batch, student_course: student_course, subjects: subjects, coming_soon_session: coming_soon_session, done_sessions: done_sessions, tobe_sessions: tobe_sessions, cancel_sessions: cancel_sessions}}
          end 
        else

        end
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
          op_att_line = op_session.op_attendance_lines.where(student_id: @op_student.id).first
        end
        respond_to do |format|
          format.html
          format.js {render 'user/open_educat/op_students/evaluation/session_evaluation', :locals => {op_faculty: op_faculty, op_batch: op_batch, op_session: op_session, op_att_line: op_att_line}}
        end

      rescue StandardError => e
        redirect_error_site(e)
      end

      def public_profile
        if params[:op_student_id].present?
          @op_student = OpStudent.where(id: params[:op_student_id].to_i).first       
          if @op_student.nil?
            if !current_user.nil? and !current_user.student_id.nil?
              redirect_to user_open_educat_op_students_public_profile_path(current_user.student_id)
            else
              redirect_to root_path
            end
          else

          end
        else 
          if !current_user.nil? and !current_user.student_id.nil?
            redirect_to user_open_educat_op_students_public_profile_path(current_user.student_id)
          else
            redirect_to root_path
          end
        end

      rescue StandardError => e
        redirect_error_site(e)
      end

      def session_student
        session = Learning::Batch::OpSession.find(params[:session_id])
        batch = session.op_batch
        all_students = User::OpTeachersService.new.teacher_class_detail batch, session

        respond_to do |format|
          format.html
          format.js { render 'user/open_educat/op_teachers/js/teacher_class_details/session_student_table', locals: { all_student: all_students, session: session }}
        end
      end

      def student_evaluate
        student = User::OpenEducat::OpStudent.where(code: params[:code]).first
        attendance = Learning::Batch::OpAttendanceLine.joins(:op_attendance_sheet).where(student_id: student.id).where(op_attendance_sheet: { session_id: params[:session_id] }).first

        respond_to do |format|
          format.html
          format.js { render 'user/open_educat/op_teachers/js/teacher_class_details/student_attendance_content', locals: { attendance: attendance }}
        end
      end

      def student_homework
        @student = @op_student
        data = User::OpenEducat::OpStudentsService.student_homework params, @student
        @courses = @student.op_courses
        @session = data[:session]
        @batch = data[:batch]
        @sessions = data[:sessions]
        @batches = data[:batches]
        @subjects = data[:subjects] 
        @lesson = data[:lesson]
        @course = data[:course]
        @subject = data[:subject]
        
        respond_to do |format|
          format.html
          format.js {render 'user/open_educat/op_students/js/table_homework_list', :locals => data}
        end

      rescue StandardError => e
        redirect_error_site(e)
      end

      def student_product
        @products = SocialCommunity::ScProduct.where(student_id: @student.id).all
        @course_products = OpenEducat::OpStudentsService.new.course_product 

      rescue StandardError => e
        redirect_error_site(e)
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

      rescue StandardError => e
        redirect_error_site(e)
      end

      def course_products
        @course = Learning::Course::OpCourse.where(id: params[:course_id]).first
        return nil if @course.blank?
        @products = SocialCommunity::ScProduct.where(course_id: @course.id).order(created_at: :DESC)

      rescue StandardError => e
        redirect_error_site(e)
      end

      def student_redeem

      end

      def student_invoice

      end

      def timetable
        @sessions = @op_student.op_sessions

        @session = @sessions.where('start_datetime >= ?', Time.now).order(start_datetime: :ASC).first
        schedules = OpTeachersService.teaching_schedule(@sessions, params)

        if request.method == 'POST'
          render json: {schedules: schedules}
        end
      end

      def student_homework_detail

      end

      def student_videos_list
        data = OpenEducat::OpStudentsService.student_homework params, @student
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

      def get_op_student
        if current_user.op_student.blank?
          @op_student = nil
        else
          @op_student = current_user.op_student
        end
      end
    end
  end
end
