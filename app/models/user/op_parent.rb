module User
  class OpParent < ApplicationRecord
    self.table_name = 'op_parent'

    has_many :op_parent_op_student_rels
    has_many :op_students, through: :op_parent_op_student_rels

    belongs_to :res_partner, :primary_key => 'id', :foreign_key => 'name'
  end
end