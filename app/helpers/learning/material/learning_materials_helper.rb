module Learning
	module Material
		module LearningMaterialsHelper
			def has_homework? user, session
				lesson = session.op_lession
				return false if lesson.blank?
				questions = lesson.questions
				return false if questions.blank?
				user_questions = Learning::LearningRecord::UserQeustion.where(user_id: user.id, question_id: questions.pluck(:id))
				return false if user_questions.blank?
				true
			end
		end
	end
end