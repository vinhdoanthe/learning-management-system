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

       # user_answers_info = Learning::Homework::UserAnswer.joins('left join user_questions as uq on uq.id = user_answers.user_question_id').joins('left join questions as q on q.id = uq.question_id').joins('left join op_lession as lesson on lesson.id = q.op_lession_id').joins('left join op_session as session on session.lession_id = lesson.id').where('session.id = ? and uq.student_id = ?', session.id, user.id).pluck(:id, :user_question_id, :state)
        questions = session.op_lession.questions
        user_questions = Learning::Homework::UserQuestion.where(student_id: user.id, question_id: questions).pluck(:id)
        user_answers = Learning::Homework::UserAnswer.where(user_question_id: user_questions).group_by{ |answers| answers.user_question }

        count_done_question = 0

        user_answers.each do |_, answers|
          states = answers.pluck(:state)
          next if states.include? 'wrong'
          count_done_question += 1
        end

        progress = count_done_question.to_s + '/' + user_questions.count.to_s
        if count_done_question == user_questions.count
          state = 'done'
        elsif count_done_question == 0
          state = 'undone'
        else
          state = 'inprogress'
        end

        return { state: state, progress: progress }
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
