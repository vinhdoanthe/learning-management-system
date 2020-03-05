module Learning
  class LearningRecordsController < ApplicationController
    before_action :authorize_access_question!, only: [:view_question, :submit_answer]

    def view_question
      # binding.pry
      user_question_id = params[:user_question_id]
      @user_question = LearningRecord::UserQuestion.find(user_question_id)
    end

    def submit_answer

    end

    def view_answer

    end

    def mark_answer

    end


    private

    def authorize_access_question!
      # binding.pry
      if params[:user_id].present? && params[:user_question_id].present?
        user_id = params[:user_id].to_i
        user_question_id = params[:user_question_id]
        user_question = Learning::LearningRecord::UserQuestion.find(user_question_id)
        if !user_question.nil?
          if user_question.student_id != user_id
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