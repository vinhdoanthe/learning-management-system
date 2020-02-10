module User
  class OpParentOpStudentRel < ApplicationRecord
    self.table_name = 'op_parent_op_student_rel'

    belongs_to :op_parent, :foreign_key => 'op_parent_id'
    belongs_to :op_student, :foreign_key => 'op_student_id'
  end
end