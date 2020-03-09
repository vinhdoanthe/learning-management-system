module Learning
  class LearningRecordsController < ApplicationController
    before_action :authorize_access_question!, only: [:view_question, :submit_answer]
    skip_before_action :verify_authenticity_token

    def view_question

    end

    def submit_answer

    end

    def view_answer

    end

    def mark_answer

    end

    def question_content
      user_question = Learning::LearningRecord::UserQuestion.find(params[:user_question_id])
      question = user_question.question

      respond_to do |format|
        format.html
        format.js { render 'learning/learning_records/partials/student_homework_question', :locals => { index: params[:index], question: question , user_question: user_question}}
      end
    end

    def answer_question
      if params[:question_choices].blank? && params[:text_answer].blank?
        state = 'fail'
      else
        result = Homework::QuestionService.new.answer_question params, current_user
        state = result[:state]
      end

      respond_to do |format|
        format.html
        format.js { render 'learning/learning_records/partials/answer_responses/success_answer', :locals => { state: state}}
      end
    end

    private

    def authorize_access_question!
      if params[:session_id].present?
        @session = Learning::Batch::OpSession.where(id: params[:session_id]).last
        @lesson = @session.op_lession
        question_ids = @lesson.questions.pluck(:id) if @lesson.present?
        @user_questions = LearningRecord::UserQuestion.where("student_id = #{current_user.id.to_s} AND question_id IN (#{question_ids.join(', ')})")

          if !@user_questions.nil?
            if @user_questions.first.student_id != current_user.id
              flash[:danger] = "Bạn không có quyền truy cập đến tài nguyên này"
              redirect_to root_path
            end
          else
            flash[:danger] = "Câu hỏi này không có trên hệ thống"
            redirect_to root_path
          end
      else
        flash[:danger] = "Bạn không có quyền truy cập đến tài nguyên này"
        redirect_to root_path
      end
    end
  end
end