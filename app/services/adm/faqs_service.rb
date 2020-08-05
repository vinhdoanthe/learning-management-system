class Adm::FaqsService

  def update_question params, user
    if params[:question_id].present?
      question = Common::Question.where(id: params[:question_id]).first
      return { type: 'dange', message: 'Câu hỏi không tồn tại hoặc đã bị xoá!' } if question.blank?
    else
      question = Common::Question.new
    end

    question.content = params[:question_content]
    question.active = params[:question_state].to_boolean
    question.created_by = user.id
    question.save

    if params[:answer_id].present?
      answer = Common::Answer.where(id: params[:answer_id]).first
      return { type: 'dange', message: 'Câu trả lời không tồn tại hoặc đã bị xoá!' } if answer.blank?
    else
      answer = Common::Answer.new
    end

    answer.faq_questions_id = question.id
    answer.content = params[:answer_content]
    answer.created_by = user.id
    answer.save

    { type: 'success', message: 'Cập nhật thành công!' }
  end
end
