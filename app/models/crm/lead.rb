class Crm::Lead < ApplicationRecord
  self.table_name = 'crm_lead'

  self.inheritance_column = 'lead_type'
end
