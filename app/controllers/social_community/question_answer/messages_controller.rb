module SocialCommunity::QuestionAnswer
  class MessagesController < ApplicationController
    
    def index
      messages = SocialCommunity::QuestionAnswer::MessagesService.get_messages(params)

      respond_to do |format|
        format.html
        format.js {
          render '', :partials => {:thread_id => thread_id, :messages => messages}
        }
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
