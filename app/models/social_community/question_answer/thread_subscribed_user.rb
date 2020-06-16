module SocialCommunity
  module QuestionAnswer
    class ThreadSubscribedUser 
      include Mongoid::Document
      include Mongoid::Timestamps
      store_in collection: 'qa_thread_subscribed_users'

      belongs_to :qa_thread, class_name: 'SocialCommunity::QuestionAnswer::Thread'
      field :user_id, type: Integer
    end
  end
end
