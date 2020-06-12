module SocialCommunity::QuestionAnswer
  class Message
    include Mongoid::Document
    include Mongoid::Timestamps

    store_in collection: "qa_messages"

    belongs_to :qa_thread, class_name: 'SocialCommunity::QuestionAnswer::Thread'
    belongs_to :qa_message, class_name: 'SocialCommunity::QuestionAnswer::Message', required: false

    field :content, type: String
    field :created_by, type: Integer
    field :updated_by, type: Integer
  end
end
