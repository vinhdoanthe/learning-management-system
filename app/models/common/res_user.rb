module Common
  class ResUser < ApplicationRecord
    self.table_name = 'res_users'
    
    has_many :op_faculties, class_name: 'User::OpenEducat::OpFaculty', foreign_key: 'related_user'
  end
end
