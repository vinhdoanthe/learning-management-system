class Crm::Claim < ApplicationRecord
  self.table_name = 'op_admission_claim'
  self.inheritance_column = 'object_type'

  has_one_attached :image

  def odoo_url
    "https://erp.teky.edu.vn/web#id=#{ self.id }&view_type=form&model=op.admission.claim&menu_id=979&action=1472"
  end
end
