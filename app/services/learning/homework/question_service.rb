class Learning::Homework::QuestionService
  def answer_question params, student
    question = Learning::Material::Question.where(id: params[:question]).first 
    user_question = find_user_question params[:user_question]

    if question.present? && user_question.present?
      user_answer = user_question.user_answers.order(created_at: :DESC).first
      if user_answer.present? && (user_answer.state == 'right' || user_answer.state == 'waiting' )
        return {state: 'done', user_question_id: user_question.id}
      else
        user_answer = create_user_answer user_question, student, params
        return { state: user_answer.state, user_question_id: user_question.id } if user_answer.present?
      end
    else
      return { message: 'Đã có lỗi xảy ra! Thử lại sau!'}
    end
  end

  def create_user_answer user_question, student, params
    question = user_question.question
    user_answer = Learning::Homework::UserAnswer.new
    user_answer.user_question_id = user_question.id
    user_answer.answer_time = Time.now
    user_answer.answer_content = params[:question_choices]
    session = Learning::Batch::OpSession.where(id: params[:session_id]).first

    if session.present?
      user_answer.batch_id = session.batch_id
      user_answer.faculty_id = session.faculty_id.to_i
      
      if question.question_type == Learning::Constant::Material::QUESTION_TEXT_RESPONSE
        user_answer.state = 'waiting'
      else
        if params[:question_choices].present?
          right_answer_ids = question.question_choices.where(is_right_choice: true).pluck(:id)
          choice_content = params[:question_choices].map{ |choice| choice.to_i }
          user_answer.state = right_answer_ids.sort == choice_content.sort ? 'right' : 'wrong'
        else
          return false
        end
      end

      if user_answer.save
        if user_answer.state == 'right'
          User::Reward::CoinStarsService.new.reward_coin_star User::Constant::TekyCoinStarActivitySetting::HOMEWORK_CHOICE, student.id, 'coin', 0
          User::Reward::CoinStarsService.new.reward_coin_star User::Constant::TekyCoinStarActivitySetting::HOMEWORK_CHOICE, student.id, 'star', 0
        end

        return user_answer
      end
      false
    end
  end

  def mark_answer params, user
    return { state: 'danger', message: 'Chưa chấm bài' } if (params[:teacher_mark_content].blank? || params[:teacher_mark].blank?)
    answer_mark = Learning::Homework::AnswerMark.new
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
    if answer_mark.save
      if user_answer.state == 'right'
        User::Reward::CoinStarsService.new.reward_coin_star User::Constant::TekyCoinStarActivitySetting::HOMEWORK_TEXT, user.id, 'coin', 0
        User::Reward::CoinStarsService.new.reward_coin_star User::Constant::TekyCoinStarActivitySetting::HOMEWORK_TEXT, user.id, 'star', 0
      end
      { state: 'success', message: 'Chấm bài thành công' }
    else
      { state: 'danger', message: 'Đã có lỗi xảy ra! Thử lại sau!' }
    end
  end

  def create_user_question student_course
    student = student_course.op_student
    return [] if student.nil?
    user = User::Account::User.where(student_id: student.id).first
    return [] if user.nil?
    subject_ids = student_course.op_subjects.pluck(:id)
    return [] if subject_ids.blank?
    user_lesson_ids = Learning::Batch::OpSession.where(batch_id: student_course.batch_id, subject_id: subject_ids).pluck(:lession_id).uniq.compact!
    return [] if user_lesson_ids.blank?
    question_ids = Learning::Material::Question.where(op_lession_id: user_lesson_ids).pluck(:id)
    errors = []

    return if question_ids.blank?
    question_ids.each do |question_id|
      existed_user_question = Learning::Homework::UserQuestion.where(student_id: user.id, question_id: question_id, op_batch_id: student_course.batch_id).first
      next if existed_user_question

      user_question = Learning::Homework::UserQuestion.new
      user_question.question_id = question_id
      user_question.student_id = user.id
      user_question.op_batch_id = student_course.batch_id
      unless user_question.save
        errors << {question_id => user_question.errors}
      end
    end

    errors
  end

  def assign_homework_by_session student_id, lesson_id, session_id
    session = Learning::Batch::OpSession.where(id: session_id).first
    session.update(lession_id: lesson_id) if session.lession_id.blank?

    lesson = session.op_lession
    questions = lesson.questions
    batch_id = session.batch_id
    user = User::Account::User.where(student_id: student_id).first

    return if (user.nil? or batch_id.nil?)
    questions.each do |question|
      existed_user_question = Learning::Homework::UserQuestion.where(student_id: user.id, question_id: question.id, op_batch_id: batch_id).first
      next if existed_user_question.present?
      
      user_question = Learning::Homework::UserQuestion.new
      user_question.op_batch_id = batch_id
      user_question.student_id = User::Account::User.where(student_id: student_id).first.id
      user_question.question_id = question.id
      user_question.save
    end
  end

  def assign_homework student_id, question_list, batch_id
    question_list.each do |question|
      create_user_question student_id, question.to_i, batch_id.to_i
    end
  end

  def create_user_question student_id, question_id, batch_id
    user_question = Learning::Homework::UserQuestion.new
    user_question.op_batch_id = batch_id
    user_question.student_id = User::Account::User.where(student_id: student_id).first.id
    user_question.question_id = question_id
    user_question.save
  end

  private

  def find_user_question user_question
    Learning::Homework::UserQuestion.where(id: user_question).first
  end

  def find_user_answer user_answer
    Learning::Homework::UserAnswer.where(id: user_answer).first
  end

  # def find_question_choice question_choice_id
  # 	Learning::Material::QuestionChoice.find(question_choice_id)
  # end

  
end
