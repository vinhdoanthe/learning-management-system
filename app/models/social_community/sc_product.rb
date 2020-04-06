class SocialCommunity::ScProduct < ApplicationRecord
	self.table_name = 'sc_products'

	belongs_to :user, class_name: 'User::User', foreign_key: 'user_id'
	belongs_to :op_student, class_name: 'User::OpStudent', foreign_key: 'student_id'
	belongs_to :op_batch, class_name: 'Learning::Batch::OpBatch', foreign_key: 'batch_id'
	belongs_to :op_course, class_name: 'Learning::Course::OpCourse', foreign_key: 'course_id'
end