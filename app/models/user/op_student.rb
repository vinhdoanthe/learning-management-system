class User::OpStudent < ApplicationRecord
  self.table_name = 'op_student'

  has_many :op_parent_op_student_rels
  has_many :op_parents, through: :op_parent_op_student_rels
end