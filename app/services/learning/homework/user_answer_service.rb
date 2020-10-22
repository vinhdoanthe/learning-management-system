class Learning::Homework::UserAnswerService

  # Lay param form
  def self.form_parameter(param_form, request)
    # Khoi tao cac gia tri ban dau
    current_date_dmy  	= Time.now.strftime('%d-%m-%Y').to_s
    from_date = Time.at(0).strftime('%d-%m-%Y').to_s
    to_date = current_date_dmy
    state = ''
    # batch_name 			= ''
    page = !param_form[:page].nil? ? param_form[:page] : 1 ;

    #if request.method == 'POST'
    if (!param_form[:frm].nil?)
      state = (param_form[:frm].present? && param_form[:frm][:state].to_s != '') ? param_form[:frm][:state].to_s : ''
      # batch_name = param_form[:frm][:batch_name].to_s != '' ? param_form[:frm][:batch_name].to_s : 'waiting'
      from_date = Date.parse(param_form[:frm][:from_date].to_s).is_a?(Date) ? param_form[:frm][:from_date].to_s : current_date_dmy
      to_date   = Date.parse(param_form[:frm][:to_date].to_s).is_a?(Date) ? param_form[:frm][:to_date].to_s : current_date_dmy
      to_date 	= Date.parse(from_date).strftime('%Y%m%d').to_i > Date.parse(to_date).strftime('%Y%m%d').to_i ? from_date : to_date
    end

    return {
      'state': state ,
      'from_date': from_date,
      'to_date': to_date,
      'page': page
    }
  end

  # Lay danh sach cac cau tra loi co cau hoi la kieu text
  def self.get_user_answers_type_question_text _params	    

    from_date = Date.parse(_params[:from_date].to_s).strftime("%Y%m%d").to_i
    to_date = Date.parse(_params[:to_date].to_s).strftime("%Y%m%d").to_i
    state = _params[:state]

    #if state.blank?
    qry = Learning::Homework::UserAnswer
      .joins("left join op_batch as bat ON bat.id = user_answers.batch_id")
      .joins("left join op_faculty as fac ON fac.id = user_answers.faculty_id")
      .joins("left join op_course as course ON course.id = bat.course_id")
      .joins("left join user_questions as uq ON uq.id = user_answers.user_question_id")
      .joins("left join questions as question ON question.id = uq.question_id")
      .joins("left join users ON users.id = uq.student_id")
      .joins("left join op_student as student ON student.id = users.student_id")
      .joins("left join op_lession as lesson ON lesson.id = question.op_lession_id")
      .joins("left join op_subject as subject ON subject.id = lesson.subject_id")
      .select("user_answers.id as id, user_answers.state, user_answers.answer_time, user_answers.batch_id, user_answers.faculty_id, fac.full_name, bat.name as batch_name, course.name as course_name, subject.level as level, lesson.name as lesson_name, student.full_name as student_name")
      .where("TO_CHAR(user_answers.answer_time, 'YYYYMMDD') >='#{from_date}' AND TO_CHAR(user_answers.answer_time, 'YYYYMMDD') <='#{to_date}'")

    count_right = qry.where(state: HomeworkConstants::UserAnswer::ANSWER_RIGHT).length
    count_waiting = qry.where(state: HomeworkConstants::UserAnswer::ANSWER_WAITING).length
    count_wrong = qry.where(state: HomeworkConstants::UserAnswer::ANSWER_WRONG).length

    if state.present?
      qry = qry.where(state: state).order("user_answers.answer_time ASC").page(_params[:page])
    else
      qry = qry.order("user_answers.answer_time ASC").page(_params[:page])
    end

    [count_right, count_waiting, count_wrong, qry]
  end	

  def self.count_done_homework student_id
    user_id = User::Account::User.where(student_id: student_id).pluck(:id).first
    return 0 if user_id.nil?

    user_question_ids = Learning::Homework::UserQuestion.where(student_id: user_id).pluck(:id)
    Learning::Homework::UserAnswer.where(user_question_id: user_question_ids, state: HomeworkConstants::UserAnswer::ANSWER_RIGHT).count
  end

end
