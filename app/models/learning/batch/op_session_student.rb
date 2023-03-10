module Learning
  module Batch
    class OpSessionStudent < ApplicationRecord
      self.table_name = 'op_session_student'

      belongs_to :op_session, class_name: 'Learning::Batch::OpSession', foreign_key: 'session_id'
      belongs_to :op_batch, class_name: 'Learning::Batch::OpBatch', foreign_key: 'batch_id'
      belongs_to :op_student_course, class_name: 'Learning::Batch::OpStudentCourse', foreign_key: 'student_course_id', required: false
      belongs_to :op_student, class_name: 'User::OpenEducat::OpStudent', foreign_key: 'student_id'
      belongs_to :op_faculty, class_name: 'User::OpenEducat::OpFaculty', foreign_key: 'faculty_id'
      belongs_to :res_company, class_name: 'Common::ResCompany', foreign_key: 'company_id'
      belongs_to :op_classroom, class_name: 'Common::OpClassroom', foreign_key: 'classroom_id'

      def self.instance_method_already_implemented?(method_name)
        return true if method_name == 'present'
        return true if method_name == 'present?'
        super
      end
    end
  end
end
