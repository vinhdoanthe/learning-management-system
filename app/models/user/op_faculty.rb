module User
  class OpFaculty < ApplicationRecord
    self.table_name = 'op_faculty'

    belongs_to :res_company, :class_name => 'Common::ResCompany', :foreign_key => 'company_id'
    belongs_to :res_partner, :primary_key => 'id', :foreign_key => 'partner_id'
    belongs_to :res_country, :class_name => 'Common::ResCountry', :foreign_key => 'country_id'
  	
  	has_many :op_sessions, :class_name => 'Learning::Batch::OpSession', :foreign_key => 'faculty_id'
  	has_many :op_batchs, :class_name => 'Learning::Batch::OpBatch', :through => 'op_sessions'
  end
end