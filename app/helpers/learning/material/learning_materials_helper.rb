module Learning
  module Material
    module LearningMaterialsHelper
      def has_homework? user, session
        lesson = session.op_lession
        return false if lesson.blank?
        questions = lesson.questions
        return false if questions.blank?
        user_questions = Learning::Homework::UserQuestion.where(student_id: user.id, question_id: questions).pluck(:id)
        return false if user_questions.blank?
        true
      end


      def done_homework? user, session
        return { state: 'Không có bài tập', progres: '' } if session.op_lession.blank?

        questions = session.op_lession.questions.pluck(:id)
        user_questions = Learning::Homework::UserQuestion.where(student_id: user.id, question_id: questions, op_batch_id: session.batch_id).pluck(:id)
        done_user_answers = Learning::Homework::UserAnswer.where(user_question_id: user_questions, state: [HomeworkConstants::UserAnswer::ANSWER_RIGHT, HomeworkConstants::UserAnswer::ANSWER_WAITING]).order(created_at: :DESC).pluck(:created_at)

        progress = done_user_answers.count.to_s + '/' + user_questions.count.to_s

        if done_user_answers.count == user_questions.count && user_questions.count != 0
          state = 'done'
        elsif done_user_answers.count == 0
          state = 'undone'
        else
          state = 'inprogress'
        end

        return { state: state, progress: progress, last_done: done_user_answers[0] }
      end

      def get_student_evaluate user, session
        student = user.op_student
        Learning::Batch::OpAttendanceLine.where(student_id: student.id, session_id: session.id).last
      end

      def enable_video?
        Settings[:enable_video]
      end
    end
  end
end
