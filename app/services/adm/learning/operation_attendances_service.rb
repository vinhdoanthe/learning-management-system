class Adm::Learning::OperationAttendancesService
  def session_student params, user
    if params[:start_time].present? && params[:end_time].present?
      query = Learning::Batch::OpSessionStudent.where(start_datetime: params[:start_time]..params[:end_time])
    else
      #query = Learning::Batch::OpSessionStudent.where(start_datetime: Time.now.beginning_of_day..Time.now.end_of_day)
      query = Learning::Batch::OpSessionStudent.where(start_datetime: (Time.now - 50.days).beginning_of_day..Time.now.end_of_day)
    end

    if params[:company_id].present?
      query = query.where(company_id: params[:company_id])
    else
      unless user.is_admin?
        company_ids = user.user_companies.pluck(:id)
        query = query.where(company_id: company_ids)
      end
    end

    query = query.joins(op_batch: :op_course).joins( :op_student, :op_faculty, :res_company, :op_classroom, :op_session)

    if params[:student_name].present?
      query = query.where("op_student.id = #{ params[:student_name] }")
    end

    if params[:session_state].present?
      query = query.where(op_session: { state: params[:session_state] })
    end

    query.order(start_datetime: :DESC).page(params[:page]).per(40).select(:id, :present, :start_datetime, :end_datetime, :note, 'op_classroom.name as classroom_name', 'op_batch.code as batch_code', 'res_company.name as company_name', 'op_student.code as student_code', 'op_student.full_name as student_name', 'op_student.id as student_id', 'op_faculty.full_name as faculty_name')
  end

  def operation_attendance id, state, note
    result = {}
    session_student = Learning::Batch::OpSessionStudent.where(id: id).first

    if session_student.blank?
      result = { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau' }
    else
      if session_student.present != state.to_boolean
        if session_student.update(present: state.to_boolean, note: note)
          if state == 'true'
            result = { type: 'success', message: 'Điểm danh thành công' }
          else
            result = { type: 'warning', message: 'Điểm danh học sinh không tới thành công!' }
          end
        else
          result = { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau' }
        end
      else
        if session_student.update(note: note)
          result = { type: 'success', message: 'Cập nhật note thành công' }
        else
          result = { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau' }
        end
      end

      result
    end
  end
end
