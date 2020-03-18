module User
  module UsersHelper

    def get_stage(op_student_id, op_batch_id)
      op_student_course = Learning::Batch::OpStudentCourse.where(student_id: op_student_id, batch_id: op_batch_id).first
      if op_student_course.nil?
        state = '';
      else
        state = op_student_course.state.to_s
      end
			state
    end

    def get_nationality(student_id)
      op_student = OpStudent.find(student_id)
      nationality_name = ''
      unless op_student.nationality.nil?
        nationality = Common::ResCountry.find(op_student.nationality)
        unless nationality.nil?
          nationality_name = nationality.name
        end
      end
      nationality_name
    end

    def get_avatar
      asset_path('global/images/avatar.svg')
      # if current_user.avatar.attached?
      #   current_user.avatar.variant(resize_to_limit: [80, 80])
      # else
      # end
    end

    def count_sessions_week reference
      current_user.send(reference).op_sessions.where('start_datetime >= ? AND end_datetime <= ?', Time.now.beginning_of_week, Time.now.end_of_week).count
    end

    def count_homework user
      questions = Learning::LearningRecord::UserQuestion.where(student_id: user.id).pluck(:id)
      questions_count = questions.count

      user_answers_count = Learning::LearningRecord::UserAnswer.where(user_question: questions.uniq, state: ['right','waiting']).count
      questions_count - user_answers_count
    end

		def count_mark_question teacher
			teacher.user_answers.where(state: 'waiting').count	
		end

    # Lay trang thai trong khoa hoc cua hoc sinh
    def get_student_batch_status(op_student_id, batch_id)
      status = {}
      status['status'] = get_stage(op_student_id, batch_id)      
      if status['status'] == Learning::Constant::STUDENT_BATCH_STATUS_ON
        status['status_html'] = '<span class="scl-success">Đang học</span>'
      elsif status['status'] == Learning::Constant::STUDENT_BATCH_STATUS_OFF
        status['status_html'] = '<span class="scl-danger">Nghỉ học</span>'
      elsif status['status'] == Learning::Constant::STUDENT_BATCH_STATUS_SAVE
        status['status_html'] = '<span class="scl-danger">Bảo lưu</span>'
      else
        status['status_html'] = '<span class="scl-danger">Đang cập nhật</span>'
      end

      return status
    end

  end
end
