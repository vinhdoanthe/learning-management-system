class Common::UserCompany < ApplicationRecord
  self.table_name = 'user_companies'

  belongs_to :user, class_name: 'User::Account::User', foreign_key: 'user_id'
  belongs_to :res_company, class_name: 'Common::ResCompany', foreign_key: 'company_id'
end
