module User
  class OpFaculty < ApplicationRecord
    self.table_name = 'op_faculty'

    belongs_to :res_company, :class_name => 'Common::ResCompany', :foreign_key => 'company_id'
    belongs_to :res_partner, :primary_key => 'id', :foreign_key => 'partner_id'
    belongs_to :res_country, :class_name => 'Common::ResCountry', :foreign_key => 'country_id'
  end
end