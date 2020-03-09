class Learning::Homework::QuestionService
	def answer_question params, student
		question = Learning::Material::Question.find(params[:question])
		user_question = find_user_question params[:user_question]
		
		if question.present?
			user_answer = user_question.user_answers.order(created_at: :DESC).first
			if user_answer && user_answer.state == 'right'
				return {state: 'done'}
			else
				user_answer = create_user_answer user_question, student, params[:question_choices]
				return { state: user_answer.state }
			end
		else
			return { message: 'Đã có lỗi xảy ra! Thử lại sau!'}
		end
	end

	def create_user_answer user_question, student, choice_content
		question = user_question.question
		user_answer = Learning::LearningRecord::UserAnswer.new
		user_answer.user_question_id = user_question.id
		user_answer.answer_time = Time.now
		user_answer.answer_content = choice_content

		if question.question_type == Learning::Constant::Material::QUESTION_TEXT_RESPONSE
			user_answer.state = 'waiting'
		else
			# question_choices = Learning::Material::QuestionChoice.where(id: params[:question_choice])
			right_answer_ids = question.question_choices.where(is_right_choice: true).pluck(:id)
			choice_content.map!{ |choice| choice.to_i }
			user_answer.state = right_answer_ids == choice_content ? 'right' : 'wrong'
		end

		user_answer.save
		user_answer
	end

	def find_user_question user_question
		Learning::LearningRecord::UserQuestion.find(user_question)
	end

	# def find_question_choice question_choice_id
	# 	Learning::Material::QuestionChoice.find(question_choice_id)
	# end
end