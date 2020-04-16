class User::OpenEducat::OpStudentController < ApplicationController
  before_action :authenticate_student!, except: [:public_profile]
  before_action :get_op_student, except: [:public_profile]

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
      format.js {render 'user/open_educat/op_student/evaluation/session_evaluation', :locals => {op_faculty: op_faculty, op_batch: op_batch, op_session: op_session, op_att_line: op_att_line}}
    end

  rescue StandardError => e
    redirect_error_site(e)
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

  rescue StandardError => e
    redirect_error_site(e)
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
