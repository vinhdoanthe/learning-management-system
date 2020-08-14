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
      puts "ANSWER ERROR: #{ params } - #{ student }"
      return { state: 'fail', message: 'Đã có lỗi xảy ra! Thử lại sau!'}
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
          User::Reward::CoinStarsService.new.reward_coin_star user_answer, student.id, 0
        end

        return user_answer
      end
      false
    end
  end

  def mark_answer params, user
    return { state: 'danger', message: 'Chưa chấm bài' } if (params[:teacher_mark_content].blank? || params[:teacher_mark].blank?)
    #  binding.pry 
    answer_mark = Learning::Homework::AnswerMark.where(user_answer_id: params[:user_answer_id]).first
    user_answer = find_user_answer params[:user_answer_id]

    if answer_mark.present?
      answer_mark.mark_content = params[:teacher_mark_content]
      user_answer.state = params[:teacher_mark] == 'true' ? 'right' : 'wrong'
      answer_mark.answer_is_right = params[:teacher_mark] == 'true' ? true : false 
    else
      answer_mark = Learning::Homework::AnswerMark.new
      answer_mark.user_answer_id = user_answer.id
      answer_mark.mark_content = params[:teacher_mark_content]

      if params[:teacher_mark] == 'true'
        user_answer.update(state: 'right')
        answer_mark.answer_is_right = true
      else
        user_answer.update(state: 'wrong')
        answer_mark.answer_is_right = false
      end
    end

    answer_mark.mark_time = Time.now
    answer_mark.teacher_id = user.id
    if answer_mark.save
      if user_answer.state == 'right'
        begin
          give_to = user_answer.user_question.user.id
        rescue NoMethodError
          give_to = nil
        end

        User::Reward::CoinStarsService.new.reward_coin_star user_answer, give_to, 0
      end
      { state: 'success', message: 'Chấm bài thành công' }
    else
      { state: 'danger', message: 'Đã có lỗi xảy ra! Thử lại sau!' }
    end
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
    unless question_list.present?
      question_list.each do |question|
        next if question.blank?
        create_user_question student_id, question.to_i, batch_id.to_i
      end
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

end
