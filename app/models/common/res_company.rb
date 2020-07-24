module Common
  class ResCompany < ApplicationRecord
    self.table_name = 'res_company'

    has_many :user_companies, class_name: "Common::UserCompany", foreign_key: 'company_id'
  end
end
