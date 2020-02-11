module User
  class ResPartner < ApplicationRecord
  self.table_name = 'res_partner'
  self.inheritance_column = 'object_type'

  has_one :op_parent
  belongs_to :res_country, :class_name => 'Common::ResCountry', :foreign_key => 'country_id'
  end
end