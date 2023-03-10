module Learning
  class LearningRecordsController < ApplicationController
    before_action :authorize_access_question!, only: [:view_question, :submit_answer]
    skip_before_action :verify_authenticity_token

    def view_question
      @session = Learning::Batch::OpSession.where(id: params[:session_id]).first
    end

    def submit_answer

    end

    def view_answer

    end

    def mark_answer
      mark = Homework::QuestionService.new.mark_answer params, current_user
      
      render json: { type: mark[:state], message: mark[:message] }
    end

    def question_content
      user_question = Learning::Homework::UserQuestion.find(params[:user_question_id])
      question = user_question.question

      respond_to do |format|
        format.html
        format.js { render 'learning/learning_records/partials/student_homework_question', :locals => { index: params[:index], question: question , user_question: user_question}}
      end
    end

    def answer_question
      user_question_id = ''
      if params[:question_choices].blank? && params[:text_answer].blank?
        state = 'fail'
      else
        result = Homework::QuestionService.new.answer_question params, current_user
        state = result[:state]
        user_question_id = result[:user_question_id]
      end

      respond_to do |format|
        format.html
        format.js { render 'learning/learning_records/partials/answer_responses/success_answer', :locals => { state: state, user_question_id: user_question_id}}
      end
    end

    def marking_question
      @batches = current_user.op_faculty.op_batches.uniq
      @batches.select!{|batch| batch.user_answers.where(state: Learning::Constant::Homework::AnswerState::STATE_WAITING).present?}
      @sessions = @batches.last.op_sessions if @batches.present?
    end

    def batch_user_answer_list
      if params[:batch_id].present? && params[:batch_id] != 'all'
        batch = Learning::Batch::OpBatch.where(id: params[:batch_id]).first
        teacher = current_user.op_faculty

        if params[:state].present? && params[:state] != 'undone'
          user_answers = Learning::Homework::UserAnswer.includes(user_question: { question: :op_lession, user: :op_student }).where(faculty_id: teacher.id, batch_id: params[:batch_id], state: ['right', 'wrong']).where(questions: {question_type: 'text'}).where.not(user_questions: { question_id: nil }).pluck(:id, :state, 'op_lession.id', 'op_lession.name', 'op_student.full_name')
        else
          user_answers = Learning::Homework::UserAnswer.includes(user_question: { question: :op_lession, user: :op_student } ).where(faculty_id: teacher.id, batch_id: params[:batch_id], state: 'waiting').where.not(user_questions: { question_id: nil }).pluck(:id, :state, 'op_lession.id', 'op_lession.name', 'op_student.full_name')
        end

        user_answers.map! { |answer| { answer_id: answer[0], state: answer[1], lesson_id: answer[2], lesson_name: answer[3], student_name: answer[4] } }
        lesson_ids = user_answers.map { |t| t[:lesson_id] }
        session_ids = Learning::Batch::OpSession.where(batch_id: batch.id, lession_id: lesson_ids.uniq).map{ |s| { s.lession_id => s.id } }
        session_ids = session_ids.reduce Hash.new, :merge

        user_answers.each do |answer|
          session = if session_ids[answer[:lesson_id]].present?
                      { session_id: session_ids[answer[:lesson_id]] }
                    else
                      { session_id: '' }
                    end
          answer.merge!(session)
        end
      else
        user_answers = {}
        batch = nil
      end

      respond_to do |format|
        format.html
        format.js { render 'learning/learning_records/marking_question/user_answer_filter', locals: { user_answers: user_answers, batch: batch}}
      end
    end

    def get_user_answer
      question = ''
      user_answer = Learning::Homework::UserAnswer.find(params[:user_answer_id])
      question = user_answer.user_question.question if user_answer.user_question.present?
      answer_mark = user_answer.answer_marks.order(created_at: :DESC).first

      respond_to do |format|
        format.html
        format.js { render 'learning/learning_records/marking_question/user_answer', locals: { question: question, answer: user_answer, answer_mark: answer_mark}}
        format.json {
          render json: {
            user_answer: user_answer,
            question: question,
            answer_mark: answer_mark
          }
        }
      end
    end

    private

    def authorize_access_question!
      if params[:session_id].present?
        @session = Learning::Batch::OpSession.where(id: params[:session_id]).last

        if @session.blank?
          flash[:danger] = "C??u h???i n??y kh??ng c?? tr??n h??? th???ng"
          redirect_to root_path
          return
        end

        @lesson = @session.op_lession

        if @lesson.blank?
          flash[:danger] = "C??u h???i n??y kh??ng c?? tr??n h??? th???ng"
          redirect_to root_path
        end

        question_ids = @lesson.questions.pluck(:id)

        @user_questions = Homework::UserQuestion.where(student_id: current_user.id, question_id: question_ids, op_batch_id: @session.batch_id)
        
        if @user_questions.present?
          if @user_questions.first.student_id != current_user.id
            flash[:danger] = "B???n kh??ng c?? quy???n truy c???p ?????n t??i nguy??n n??y"
            redirect_to root_path
          end
        else
          flash[:danger] = "C??u h???i n??y kh??ng c?? tr??n h??? th???ng"
          redirect_to root_path
        end
      else
        flash[:danger] = "B???n kh??ng c?? quy???n truy c???p ?????n t??i nguy??n n??y"
        redirect_to root_path
      end
    end
  end
end
