module SocialCommunity::QuestionAnswer
  class MessagesController < ApplicationController

    def index
      return if !params[:thread_id].present?
      messages = SocialCommunity::QuestionAnswer::MessagesService.get_messages(params)
      puts "count: #{messages.count}"
      unless messages.empty?
        puts 'rendered'
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
      permitted_params = message_params
      message= SocialCommunity::QuestionAnswer::MessagesService.create_message(permitted_params, current_user)
      unless message.nil?
        respond_to do |format|
          format.html
          format.js {
            render 'social_community/question_answer/js/add_new_reply', :locals => {:thread_id => message.qa_thread_id, :message => message}
          }
        end
      end
    end

    def edit
    end
    def update

    end

    def destroy

    end

    private
    def message_params
      params.permit(:thread_id, :content)
    end
  end
end
