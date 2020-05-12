class Learning::Batch::SessionStudentFeedback < ApplicationRecord
  self.table_name = 'session_student_feedbacks'
  
  belongs_to :user, class_name: 'User::Account::User', foreign_key: 'feedback_by'

  acts_as_notifiable :users,
    targets: ->(feedback, key) {
    (Learning::Batch::SessionStudentFeedbacksService.get_subscribed_users feedback.session_id).uniq
  },
  notifiable_path: :feedback_path

  def feedback_path
    session_student_feedback_path(id)
  end

  def create_notifications
    notify :users, key: 'feedback.create'
  end
end
