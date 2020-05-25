class SocialCommunity::ScStudentProject < ApplicationRecord
  self.table_name = 'sc_student_projects'

  belongs_to :user, class_name: 'User::Account::User', foreign_key: 'user_id'
  belongs_to :op_student, class_name: 'User::OpenEducat::OpStudent', foreign_key: 'student_id'
  belongs_to :op_batch, class_name: 'Learning::Batch::OpBatch', foreign_key: 'batch_id'
  belongs_to :op_course, class_name: 'Learning::Course::OpCourse', foreign_key: 'course_id'
  belongs_to :op_subject, class_name: 'Learning::Course::OpSubject', foreign_key: 'subject_id'
  belongs_to :sc_post, class_name: 'SocialCommunity::Feed::StudentProjectPost', foreign_key: 'sc_post_id'
end
