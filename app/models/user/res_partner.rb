module User
  class ResPartner < ApplicationRecord
  self.table_name = 'res_partner'
  self.inheritance_column = 'object_type'

  has_one :op_parent
  belongs_to :res_country, :class_name => 'Common::ResCountry', :foreign_key => 'country_id'
  belongs_to :res_company, :class_name => 'Common::ResCompany', :foreign_key => 'company_id'
  end
end
