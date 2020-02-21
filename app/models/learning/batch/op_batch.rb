module Learning
  module Batch
    class OpBatch < ApplicationRecord
      self.table_name = 'op_batch'

      belongs_to :op_course, class_name: 'Learning::Course::OpCourse', foreign_key: 'course_id'
      belongs_to :res_company, class_name: 'Common::ResCompany', foreign_key: 'company_id'
      has_many :op_student_courses, :foreign_key => 'batch_id'
      belongs_to :op_batch_type, :foreign_key => 'type_id'

      has_many :op_sessions, class_name: 'Learning::Batch::OpSession', foreign_key: 'batch_id'
      has_many :op_session_students, class_name: 'Learning::Batch::OpSessionStudent', foreign_key: 'batch_id'
      has_many :op_faculties, -> {distinct}, :class_name => 'User::OpFaculty', through: :op_sessions
      has_many_attached :photos
      # TO DO batch status
      def check_status
        self.active
      end

      def current_session_level
        last_done_session = OpSession.where(batch_id: self.id, state: Learning::Constant::Batch::Session::STATE_DONE).last
        if last_done_session.nil?
          'Chưa có buổi học nào diễn ra'
        else
          if last_done_session.op_subject.nil?
            last_done_session.count.to_s + 'Chưa có dữ liệu Subject'
          else
            last_done_session.count.to_s + ' - Level ' + last_done_session.op_subject.level.to_s
          end
        end
      end
    end
  end
end