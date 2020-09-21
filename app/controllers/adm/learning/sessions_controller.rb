class Adm::Learning::SessionsController < Adm::AdmController
  skip_before_action :verify_authenticity_token
  before_action :find_session, only: [:session_photos, :session_attendances, :session_videos, :session_info, :student_attendance_detail]

 rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, alert: exception.message
 end

  def index
    @allow_companies =  if current_user.is_operation_admin?
                        current_user.res_companies
                      else
                        Common::ResCompany.all
                      end
    allow_company_ids = @allow_companies.pluck(:id)
    @allow_batches = Learning::Batch::OpBatch.where(company_id: allow_company_ids, state: [Learning::Constant::Batch::STATE_APPROVE, Learning::Constant::Batch::STATE_CONFIRM])
    @session_states = Learning::Batch::OpSession.pluck(:state).uniq
  end

  def filter_sessions
    service = Adm::Learning::SessionsService.new
    sessions = service.session_index params, current_user

    respond_to do |format|
      format.html
      format.js { render 'adm/learning/sessions/index_content', locals: { sessions: sessions, page: params[:page].to_i } }
    end
  end

  def session_photos
    photos = @session.photos

    respond_to do |format|
      format.html
      format.js { render 'adm/learning/sessions/js/session_photos', locals: { photos: photos } }
    end
  end

  def session_videos

  end

  def session_info
    batch = @session.op_batch
    course = Learning::Course::OpCourse.where(id: @session.course_id).first
    company = @session.res_company
    class_room = @session.op_classroom

    if batch.present?
      students = Adm::Learning::SessionsService.new.session_students @session, batch
    end

    respond_to do |format|
      format.html
      format.js { render 'adm/learning/sessions/js/session_attendance', locals: { batch: batch, session: @session, course: course, students: students, company: company, class_room: class_room } }
    end
  end

  def student_attendance_detail
    att = Learning::Batch::OpAttendanceLine.where(id: params[:attendance_id]).first
    student = att.op_student
    teacher = @session.op_faculty

    respond_to do |format|
      format.html
      format.js { render 'adm/learning/sessions/js/student_attendance_detail', locals: { session: @session, attendance: att, student: student, teacher: teacher } }
    end
  end

  def update_attendance_line
    att = Learning::Batch::OpAttendanceLine.where(id: params[:attendance_id]).first

    if att.update(attendance_state: params[:attendance_state], operation_comment: params[:note])
      if params[:attendance_state] == OpAttendanceLineConstant::State::STATE_PUBLISHED
        render json: { type: 'success', message: 'Cập nhật đánh giá đạt yêu cầu thành công' }
      else
        render json: { type: 'success', message: 'Cập nhật đánh giá không đạt yêu cầu thành công' }
      end
    else
      render json: { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau!' }
    end
  end

  private

  def find_session
    @session = Learning::Batch::OpSession.where(id: params[:session_id]).first
  end
end
