class Report::CompanyService
  
  # Lay danh sach company hoat dong
  def self.get_list_company
    return Common::ResCompany.where.not(:id => [3,19,36,10,11,17,12,13,18,16]).select(:id, :name, :code).order(code: :DESC)
  end
  
end
