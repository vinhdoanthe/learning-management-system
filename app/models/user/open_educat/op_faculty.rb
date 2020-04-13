module User
  class OpFaculty < ApplicationRecord
    self.table_name = 'op_faculty'

    belongs_to :res_company, :class_name => 'Common::ResCompany', :foreign_key => 'company_id'
    belongs_to :res_partner, :primary_key => 'id', :foreign_key => 'partner_id'
    belongs_to :res_country, :class_name => 'Common::ResCountry', :foreign_key => 'country_id'
    belongs_to :res_user, class_name: 'Common::ResUser', foreign_key: 'related_user'

    has_many :op_sessions, :class_name => 'Learning::Batch::OpSession', :foreign_key => 'faculty_id'
    has_many :op_batches, :class_name => 'Learning::Batch::OpBatch', :through => 'op_sessions'
    has_many :user_answers, :class_name => 'Learning::Homework::UserAnswer', foreign_key: 'faculty_id'
  end
end
