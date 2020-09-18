class Adm::Learning::BatchesService
  def index params, user
    company_ids = user.user_companies.pluck(:company_id)
    query = ''
    query += "batch.code = '#{ params[:code] }' AND " if params[:code].present?
    query += "batch.state = '#{ params[:state] }' AND " if params[:state].present?
    query += "batch.select_place = '#{ params[:select_place] }' AND " if params[:select_place].present?
    query += "batch.company_id IN ('#{ company_ids.join(',') }') AND " if company_ids.present?
    query = query[0..-5]
    hash_query = {}
    hash_query.merge({ op_sessions: { start_datetime: params[:start_time]..params[:end_time] }}) if (params[:start_time].present? && params[:end_time].present?)
    Learning::Batch::OpBatch.where(query).where(hash_query).joins(:op_sessions, :op_faculties, :op_student_courses).params[:page].per(25).select(:id, :code, :course_id, :select_place, :start_date, :state, 'op_faculty.full_name as teacher_name', 'op_session.start_datetime as session_start', "SUM(case WHEN op_student_course.state = 'on' then 1 ELSE 0 END) as active_student", "COUNT(op_student_course.id) as total_student").group(:id, 'session_start', 'teacher_name')
  end
end
