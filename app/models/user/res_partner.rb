module User
  class ResPartner < ApplicationRecord
  self.table_name = 'res_partner'
  self.inheritance_column = 'object_type'

  has_one :op_parent
end
end