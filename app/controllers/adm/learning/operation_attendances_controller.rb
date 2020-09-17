class Adm::Learning::OperationAttendancesController < Adm::AdmController
  def index
    @session_states = Learning::Batch::OpSession.pluck(:state).uniq
    company_ids = current_user.user_companies.pluck(:company_id)
    @allow_companies = Common::ResCompany.where(id: company_ids)

    if current_user.is_admin?
      @allow_companies = Common::ResCompany.all
    end
  end

  def index_content
    @session_students = Adm::Learning::OperationAttendancesService.new.session_student params, current_user
    @students = {}
    @session_students.each do |ss|
      @students.merge! ({ ss.student_id => ss.student_name }) if @students[ss.id].blank?
    end

    @filter_student = params[:student_name].present?
  end

  def operation_attendance
    result = Adm::Learning::OperationAttendancesService.new.operation_attendance params[:id], params[:state], params[:note]

    render json: result
  end
end
