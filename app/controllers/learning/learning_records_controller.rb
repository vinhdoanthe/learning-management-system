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
      mark = Homework::QuestionService.new.mark_answer params, current_user
      if mark
        result = { type: 'success', message: "Chấm bài thành công"}
      else
        result = { type: 'success', message: "Chấm bài thành công"}
      end
      render json: result
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

    def marking_question
      @batches = current_user.op_faculty.op_batches.uniq
      @batches.select!{|batch| batch.user_answers.present?}
      @sessions = @batches.last.op_sessions if @batches.present?
    end

    def batch_user_answer_list
      batch = Learning::Batch::OpBatch.find(params[:batch_id])
      user_answers = batch.user_answers.where(state: 'waiting')
      respond_to do |format|
        format.html
        format.js { render 'learning/learning_records/marking_question/user_answer_filter', locals: { user_answers: user_answers}}
      end
    end

    def get_user_answer
      user_answer = Learning::LearningRecord::UserAnswer.find(params[:user_answer_id])
      question = user_answer.user_question.question
      respond_to do |format|
        format.html
        format.js { render 'learning/learning_records/marking_question/user_answer', locals: { question: question, answer: user_answer}}
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