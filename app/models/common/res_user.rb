module Common
  class ResUser < ApplicationRecord
    self.table_name = 'res_users'
    
    has_many :op_faculties, class_name: 'User::OpenEducat::OpFaculty', foreign_key: 'related_user'
    belongs_to :res_partner, class_name: 'User::ResPartner', foreign_key: 'partner_id'
  end
end
