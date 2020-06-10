module SocialCommunity::QuestionAnswer
  class ThreadsController < ApplicationController
    def create
      new_thread = SocialCommunity::QuestionAnswer::ThreadsService.create_thread(permit_params)
    end

    def update

    end

    def destroy

    end

    private
    def permit_params
      params.require(:thread).permit(:session_id, :lesson_id, :subject)
    end
  end
end
