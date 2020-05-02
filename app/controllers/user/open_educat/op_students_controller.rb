module User
  module OpenEducat
    class OpStudentsController < ApplicationController
      before_action :authenticate_student!, except: [:public_profile, :session_student, :student_evaluate, :timetable]
      before_action :get_op_student, except: [:public_profile, :session_student, :student_evaluate]
      skip_before_action :authenticate_user!, only: [:public_profile] 
      skip_before_action :verify_authenticity_token, only: [:timetable_content]

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
        photos = []
        if params[:session_id].present?
          op_session = Learning::Batch::OpSession.find(params[:session_id].to_i)
          unless op_session.nil?
            op_batch = op_session.op_batch
            op_faculty = op_session.op_faculty
            op_att_line = op_session.op_attendance_lines.where(student_id: @op_student.id).first
            photos = SocialCommunity::Photo.where(session_id: op_session.id).to_a
            photos = photos.take(5) if !photos.empty?
          end
        end
        respond_to do |format|
          format.html
          format.js {render 'user/open_educat/op_students/evaluation/session_evaluation', :locals => {op_faculty: op_faculty, op_batch: op_batch, op_session: op_session, op_att_line: op_att_line, photos: photos}}
        end

      rescue StandardError => e
        redirect_error_site(e)
      end


      # Lấy các thông tin để hiển thị cho trang Public Profile
      # Return
      # - user
      # - op_student
      # - achievements
      # - badges
      # - products
      # - featured photos
      def public_profile
        if params[:op_student_id].present?
          @op_student = OpStudent.where(id: params[:op_student_id].to_i).first       
          if @op_student.nil?
            if !current_user.nil? and !current_user.student_id.nil?
              redirect_to user_open_educat_op_students_public_profile_path(current_user.student_id) and return
            else
              redirect_to root_path and return
            end
          end
        else # params[:op_student_id] == nil 
          if !current_user.nil? and !current_user.student_id.nil?
            redirect_to user_open_educat_op_students_public_profile_path(current_user.student_id) and return
          else
            redirect_to root_path and return
          end
        end
        # Get response data
        public_user = User::Account::User.where(student_id: @op_student.id).first
        achievements = []
        badges = []
        products = []
        featured_photos = User::OpenEducat::OpStudentsService.get_featured_photos @op_student.id
        respond_to do |format|
          format.html {render 'public_profile', :locals => {
            op_student: @op_student,
            public_user: public_user,
            achievements: achievements,
            badges: badges,
            products: products,
            featured_photos: featured_photos
          }}
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
        data = User::OpenEducat::OpStudentsService.new.student_homework @student, params
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
        @session = User::OpenEducat::OpStudentsService.get_comming_soon_session(@op_student.id)
      end

      def timetable_content
        if !params[:date].present?
          filter_date = Time.now
        else
          filter_date = DateTime.parse(params[:date]).to_time
        end

        student_courses = Learning::Batch::OpStudentCourse.where(student_id: @op_student.id)
        batch_ids = student_courses.pluck(:batch_id)
        subject_ids = []
        sessions = []
        start_time = filter_date.beginning_of_week
        end_time = filter_date.end_of_week
        student_courses.each do |sc|
          subject_ids << sc.op_subjects.pluck(:id)
        end

        subject_ids = subject_ids.flatten.uniq

        batch_ids.each do |batch_id|
          sessions << Learning::Batch::OpBatchService.get_sessions(batch_id, @op_student.id, subject_ids, {start: start_time, end: end_time}) 
        end

        sessions = sessions.flatten.uniq
        schedules = User::OpenEducat::OpStudentsService.new.timetable sessions

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

      def filter_course_homework
        course = Learning::Course::OpCourse.where(id: params[:course]).first
        op_student_courses = Learning::Batch::OpStudentCourse.where(student_id: @op_student.id, course_id: course.id)
        #subject_ids = op_student_courses.pluck(:subject_id).uniq
        #subjects = Learning::Course::OpSubject.where(id: subject_ids)
        batch_ids = op_student_courses.pluck(:batch_id).uniq
        batches = Learning::Batch::OpBatch.where(id: batch_ids)
        active_session = Learning::Batch::OpBatchService.last_done_session(@op_student.id, batch_ids, [])
        batch = active_session.op_batch
        subject = active_session.op_subject
        lesson = active_session.op_lession
        subjects = Learning::Course::OpSubject.where(id: batch.op_sessions.pluck(:subject_id).uniq)

        sessions = Learning::Batch::OpBatchService.get_sessions( batch_id = batch.id, student_id = @op_student.id, subject_ids = [subject.id]).select{ |s| s.state != Learning::Constant::Batch::Session::STATE_CANCEL}

        respond_to do |format|
          format.html
          format.js {render 'user/open_educat/op_students/js/table_homework_list', :locals => {batch: batch, batches: batches, session: session, sessions: sessions, subject: subject, subjects: subjects, course: course, errors: '', lesson: lesson}}
        end

      end

      def filter_batch_homework
        batch = Learning::Batch::OpBatch.where(id: params[:batch]).first
        subjects = Learning::Course::OpSubject.where(id: batch.op_sessions.pluck(:subject_id).uniq)
        course = batch.op_course
        batches = ''
        sessions = Learning::Batch::OpBatchService.get_sessions( batch_id = batch.id, student_id = @op_student.id, subject_ids = subjects.pluck(:id)).select{|s| s.state != Learning::Constant::Batch::Session::STATE_CANCEL}
        active_session = sessions.sort_by{|s| s.start_datetime}.select{|s| s.state == Learning::Constant::Batch::Session::STATE_DONE}.last
        active_session = sessions.last if active_session.blank?

        if active_session.present?
          subject = active_session.op_subject
          sessions.select{|s| s.subject_id == subject.id}
          #subjects = Learning::Course::OpCourse.where(id: sessions.pluck(:subject_id))
          lesson = active_session.op_lession

          respond_to do |format|
            format.html
            format.js {render 'user/open_educat/op_students/js/table_homework_list', :locals => {batch: batch, batches: batches, session: active_session, sessions: sessions, subject: subject, subjects: subjects, course: course, errors: '', lesson: lesson}}
          end
        else
          respond_to do |format|
            format.js { render 'user/open_educat/op_students/js/table_homework_list', :locals => { errors: true } } 
          end
        end
      end

      def filter_subject_homework
        subject = Learning::Course::OpSubject.where(id: params[:subject]).first
        course = subject.op_course
        batch = Learning::Batch::OpBatch.where(id: params[:batch]).first
        sessions = Learning::Batch::OpBatchService.get_sessions( batch_id = batch.id, student_id = @op_student.id, subject_ids = subject.id).select{|s| s.state != Learning::Constant::Batch::Session::STATE_CANCEL}
        active_session = sessions.sort_by{|s| s.start_datetime}.select{|s| s.state == Learning::Constant::Batch::Session::STATE_DONE}.last
        active_session = sessions.last if active_session.blank?

        if active_session.present?
          subject = active_session.op_subject
          lesson = active_session.op_lession
          batches = ''
          subjects = ''

          respond_to do |format|
            format.html
            format.js {render 'user/open_educat/op_students/js/table_homework_list', :locals => {batch: batch, batches: batches, session: active_session, sessions: sessions, subject: subject, subjects: subjects, course: course, errors: '', lesson: lesson}}
          end
        else
          respond_to do |format|
            format.js { render 'user/open_educat/op_students/js/table_homework_list', :locals => { errors: true } } 
          end
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
