module Learning
  module Batch
    class OpBatch < ApplicationRecord
      self.table_name = 'op_batch'

      belongs_to :op_course, class_name: 'Learning::Course::OpCourse', foreign_key: 'course_id'
      belongs_to :res_company, class_name: 'Common::ResCompany', foreign_key: 'company_id'
      has_many :op_student_courses, :foreign_key => 'batch_id'
      belongs_to :op_batch_type, :foreign_key => 'type_id'

      has_many :op_sessions, class_name: 'Learning::Batch::OpSession', foreign_key: 'batch_id'
      has_many :op_faculties, -> { distinct }, :class_name => 'User::OpFaculty', through: :op_sessions
      
      # TO DO batch status
      def check_status
        self.active
      end
    end
  end
end