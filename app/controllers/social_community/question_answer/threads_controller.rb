module SocialCommunity::QuestionAnswer
  class ThreadsController < ApplicationController
    def show
      @thread = SocialCommunity::QuestionAnswer::Thread.where(_id: params[:id]).first
      if !@thread.nil?
        @messages = SocialCommunity::QuestionAnswer::Message.where(qa_thread_id: @thread._id).order(:created_at => :ASC)
      else
        @messages = nil
      end
    end

    def create
      new_thread = SocialCommunity::QuestionAnswer::ThreadsService.create_thread(permit_params, current_user)
      if new_thread.nil?

      else
        respond_to do |format|
          format.html
          format.js {
            render 'social_community/question_answer/js/add_new_thread', :locals => {thread: new_thread}
          }
        end
      end
    end

    def index
      threads = SocialCommunity::QuestionAnswer::ThreadsService.get_threads(params, current_user) 
      respond_to do |format|
        format.html
        format.js {
          render 'social_community/question_answer/js/render_qa_area', :locals => {:threads => threads}
        }
      end
    end

    def my_threads
      @threads = SocialCommunity::QuestionAnswer::ThreadsService.all_threads params, current_user 
    end

    def new
    end

    def edit
    end
    def update

    end

    def destroy

    end

    private
    def permit_params
      params.permit(:session_id, :lesson_id, :subject)
    end
  end
end
