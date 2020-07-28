class Learning::Batch::SessionStudentFeedback < ApplicationRecord
  self.table_name = 'session_student_feedbacks'
  
  belongs_to :user, class_name: 'User::Account::User', foreign_key: 'feedback_by'
  belongs_to :op_session, class_name: 'Learning::Batch::OpSession', foreign_key: 'session_id'
  belongs_to :feeling_type, class_name: 'Common::FeelingType', foreign_key: 'feeling_type_id'

  acts_as_notifiable :users,
    targets: ->(feedback, key) {
    (Learning::Batch::SessionStudentFeedbacksService.get_subscribed_users feedback.session_id).uniq
  }

  def notifiable_path post, key
    learning_feedback_path(id)
  end

  def create_notifications
    notify :users, key: 'feedback.create'
  end
end
