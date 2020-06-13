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

    # params
    # thread_id
    # content
    def self.create_message message_params, user
      return nil if message_params.empty? or user.nil?

      message = SocialCommunity::QuestionAnswer::Message.new
      message.qa_thread_id = message_params[:thread_id]
      message.content = message_params[:content]
      message.created_by = user.id
      if message.save
        message
      else
        nil
      end
    end

  end
end
