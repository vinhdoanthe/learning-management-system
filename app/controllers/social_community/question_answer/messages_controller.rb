module SocialCommunity::QuestionAnswer
  class MessagesController < ApplicationController

    def index
      return if !params[:thread_id].present?
      binding.pry 
      messages = SocialCommunity::QuestionAnswer::MessagesService.get_messages(params)
      unless messages.empty?
        respond_to do |format|
          format.html
          format.js {
            render 'social_community/question_answer/js/messages', :locals => {:thread_id => params[:thread_id], :messages => messages}
          }
        end
      end
    end

    def new
    end

    def create
    end

    def edit
    end
    def update

    end

    def destroy

    end
  end
end
