class Learning::Homework::UserAnswerService
	
	
	# Lay param form
	def self.form_paramater(param_form, request)
	    
	    # Khoi tao cac gia tri ban dau
	    current_date_dmy  	= Time.now.strftime('%d-%m-%Y').to_s
	    from_date 			= to_date = current_date_dmy
	    state 				= 'waiting'
	    batch_name 			= ''
	    page 				= !param_form[:page].nil? ? param_form[:page] : 1 ;
	    
	    #if request.method == 'POST'

	    if (!param_form[:frm].nil?)
	      
	      state = param_form[:frm].nil? && param_form[:frm][:state].to_s != '' ? param_form[:frm][:state].to_s : 'waiting'
	      batch_name = param_form[:frm][:batch_name].to_s != '' ? param_form[:frm][:batch_name].to_s : 'waiting'
	      
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
    	
    	from_date 	= Date.parse(_params[:from_date].to_s).strftime("%Y%m%d").to_i
    	to_date 	= Date.parse(_params[:to_date].to_s).strftime("%Y%m%d").to_i
		state 		= _params[:state]

		if state.nil?
			qry = Learning::Homework::UserAnswer
			.joins("left join op_batch as bat ON bat.id = user_answers.batch_id")
			.joins("left join op_faculty as fac ON fac.id = user_answers.faculty_id")
			.joins("left join user_questions as u_q ON u_q.id = user_answers.user_question_id")
			.joins("left join op_student as student ON student.id = u_q.student_id")
			.select("user_answers.state, user_answers.answer_time, user_answers.batch_id, user_answers.faculty_id,
				fac.full_name, bat.name as batch_name, u_q.student_id, student.full_name as student_full_name")
			.where("TO_CHAR(user_answers.answer_time, 'YYYYMMDD') >='#{from_date}' AND TO_CHAR(user_answers.answer_time, 'YYYYMMDD') <='#{to_date}'")
			.order("user_answers.answer_time DESC")
		else
			qry = Learning::Homework::UserAnswer
			.joins("left join op_batch as bat ON bat.id = user_answers.batch_id")
			.joins("left join op_faculty as fac ON fac.id = user_answers.faculty_id")
			.joins("left join user_questions as u_q ON u_q.id = user_answers.user_question_id")			
			.joins("left join users as u ON u.student_id = u_q.student_id")
			.joins("left join op_student as student ON student.id = u.student_id")
			.joins("left join res_partner as partner ON partner.id = fac.partner_id")
			.select("user_answers.state, user_answers.answer_time, user_answers.batch_id, user_answers.faculty_id, 
				fac.full_name, partner.display_name as teacher_name, partner.email as teacher_email,
				partner.mobile as teacher_mobile, bat.name as batch_name, u_q.student_id, student.full_name as student_full_name")
			.where(:state => state)
			.where("TO_CHAR(user_answers.answer_time, 'YYYYMMDD') >='#{from_date}' AND TO_CHAR(user_answers.answer_time, 'YYYYMMDD') <='#{to_date}'")
			.order("user_answers.answer_time DESC")
		end

    	return qry.page(_params[:page].to_i).per(10)
  	end	
end