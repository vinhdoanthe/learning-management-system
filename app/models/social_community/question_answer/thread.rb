module SocialCommunity::QuestionAnswer
  class Thread
    include Mongoid::Document
    include Mongoid::Timestamps
    store_in collection: "qa_threads"

    field :course_id, type: Integer
    field :batch_id, type: Integer
    field :subject_id, type: Integer
    field :lesson_id, type: Integer
    field :session_id, type: Integer
    field :subject, type: String
    field :permission, type: String
    field :created_by, type: Integer
    field :updated_by, type: Integer

    has_many :qa_messages, class_name: 'SocialCommunity::QuestionAnswer::Message'
  end
end
