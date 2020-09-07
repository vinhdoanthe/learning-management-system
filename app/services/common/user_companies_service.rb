class Common::UserCompaniesService
  def create user_id, company_id
    user_company = Common::UserCompany.new
    user_company.user_id = user_id
    user_company.company_id = company_id
    user_company.save
  end
end
