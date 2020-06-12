module SocialCommunity::QuestionAnswer
  class Thread
    include Mongoid::Document
    include Mongoid::Timestamps
    include ActivityNotification::Models
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
    
    acts_as_notifiable :users,
      targets: ->(thread, key) {
      if key == 'qa_thread.create'
        [SocialCommunity::QuestionAnswer::ThreadsService.get_faculty_user(thread)]
      elsif key == 'qa_thread.reply'
        [User::Account::User.where(id: thread.created_by).first] 
      end
    },
    notifiable_path: :thread_path

    def thread_path
      social_community_question_answer_thread_path(thread)
    end
  end
end
