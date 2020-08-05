class Adm::FaqsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def index
    @questions = Common::Question.all
  end

  def new
  end

  def show
    @question = Common::Question.where(id: params[:question_id]).first
    @answer = @question.answer
  end

  def update_question
    result = Adm::FaqsService.new.update_question params, current_user

    render json: result
  end

  def delete_faq
  end

end
