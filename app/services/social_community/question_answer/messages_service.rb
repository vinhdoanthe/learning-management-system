module SocialCommunity::QuestionAnswer
  class MessagesService
    
    # params:
    # thread_id
    # start_datetime
    # end_datetime
    # offset
    # limit
    # user_id
    def self.get_messages params
      if params[:thread_id].present?
        messages = SocialCommunity::QuestionAnswer::Message
          .where(:qa_thread_id => params[:thread_id].to_s)
          .order(:updated_at => :DESC)
          .only(:created_by, :content, :updated_at).to_a
      else
      end

      messages
    end

  end
end
