module Redeem
  class RedeemProductItem < ApplicationRecord
    self.table_name = 'redeem_product_items'
    
    belongs_to :redeem_product, class_name: 'Redeem::RedeemProduct', foreign_key: 'product_id'
    belongs_to :redeem_transaction, class_name: 'Redeem::RedeemTransaction', foreign_key: 'transaction_id'
    belongs_to :redeen_product_size, class_name: 'Redeem::RedeemProductSize', foreign_key: 'size_id'
    belongs_to :redeem_product_color, class_name: 'Redeem::RedeemProductColor', foreign_key: 'color_id'
    belongs_to :company, class_name: 'Common::ResCompany', foreign_key: 'company_id', required: false

  end
end
