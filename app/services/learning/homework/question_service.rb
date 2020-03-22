class Learning::Homework::QuestionService
  def answer_question params, student
    question = Learning::Material::Question.find(params[:question])
    user_question = find_user_question params[:user_question]

    if question.present?
      user_answer = user_question.user_answers.order(created_at: :DESC).first
      if user_answer && user_answer.state == 'right'
        return {state: 'done'}
      else
        user_answer = create_user_answer user_question, student, params
        return { state: user_answer.state }
      end
    else
      return { message: 'Đã có lỗi xảy ra! Thử lại sau!'}
    end
  end

  def create_user_answer user_question, student, params
    question = user_question.question
    user_answer = Learning::LearningRecord::UserAnswer.new
    user_answer.user_question_id = user_question.id
    user_answer.answer_time = Time.now
    user_answer.answer_content = params[:choice_content]
    session = Learning::Batch::OpSession.find(params[:session_id])
    user_answer.batch_id = session.batch_id
    user_answer.faculty_id = session.faculty_id.to_i

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

  def mark_answer params, user
    answer_mark = Learning::LearningRecord::AnswerMark.new
    user_answer = find_user_answer params[:user_answer_id]
    answer_mark.user_answer_id = user_answer.id
    answer_mark.mark_content = params[:teacher_mark_content]

    if params[:teacher_mark] == 'true'
      user_answer.update(state: 'right')
      answer_mark.answer_is_right = true
    else
      user_answer.update(state: 'wrong')
      answer_mark.answer_is_right = false
    end

    answer_mark.mark_time = Time.now
    answer_mark.teacher_id = user.id
    answer_mark.save
  end

  def create_user_question student_course
    student = student_course.op_student
    user = User::User.where(student_id: student.id).first
    user_lesson_ids = student.op_sessions.pluck(:lession_id).uniq.compact!
    question_ids = Learning::Material::Question.where(op_lession_id: user_lesson_ids).pluck(:id)
    errors = []

    question_ids.each do |question_id|
      user_question = Learning::LearningRecord::UserQuestion.new
      user_question.question_id = question_id
      user_question.student_id = user.id
      user_question.op_batch_id = student_course.batch_id
      unless user_question.save
        errors << {question_id => user_question.errors}
      end
    end

    errors
  end

  private

  def find_user_question user_question
    Learning::LearningRecord::UserQuestion.find(user_question)
  end

  def find_user_answer user_answer
    Learning::LearningRecord::UserAnswer.find(user_answer)
  end

  # def find_question_choice question_choice_id
  # 	Learning::Material::QuestionChoice.find(question_choice_id)
  # end
end
