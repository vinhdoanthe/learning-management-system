module Learning
  module Batch
    class OpBatch < ApplicationRecord
      self.table_name = 'op_batch'

      belongs_to :op_course, class_name: 'Learning::Course::OpCourse', foreign_key: 'course_id'
      belongs_to :res_company, class_name: 'Common::ResCompany', foreign_key: 'company_id'
    end
  end
end