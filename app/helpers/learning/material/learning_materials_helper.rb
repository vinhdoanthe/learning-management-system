module Learning
	module Material
		module LearningMaterialsHelper
			def has_homework? user, session
				lesson = session.op_lession
				return false if lesson.blank?
				questions = lesson.questions
				return false if questions.blank?
				user_questions = Learning::LearningRecord::UserQuestion.where(student_id: user.id, question_id: questions).pluck(:id)
				return false if user_questions.blank?
				true
			end

			def done_homework? user, session
				questions = session.op_lession.questions
				user_questions = Learning::LearningRecord::UserQuestion.where(student_id: user.id, question_id: questions).pluck(:id)
				user_answer_states = Learning::LearningRecord::UserAnswer.where(user_question_id: user_questions).pluck(:state)
				if user_answer_states.include? 'wrong'
					return false
				else
					return true
				end
			end
		end
	end
end
