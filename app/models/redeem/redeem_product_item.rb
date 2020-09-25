include RedeemConstants::ProductItem

module Redeem
  class RedeemProductItem < ApplicationRecord
    self.table_name = 'redeem_product_items'
    extend Enumerize

    enumerize :state, in: [STATE_AVAILABLE, STATE_LOCKED, STATE_SOLD]

    belongs_to :redeem_product, class_name: 'Redeem::RedeemProduct', foreign_key: 'product_id'
    belongs_to :redeem_transaction, class_name: 'Redeem::RedeemTransaction', foreign_key: 'transaction_id', required: false
    belongs_to :redeem_product_size, class_name: 'Redeem::RedeemProductSize', foreign_key: 'size_id'
    belongs_to :redeem_product_color, class_name: 'Redeem::RedeemProductColor', foreign_key: 'color_id'
    belongs_to :company, class_name: 'Common::ResCompany', foreign_key: 'company_id', required: false

    validates :item_code, uniqueness: true

    def available?
      state == STATE_AVAILABLE
    end
    
    def locked?
      state == STATE_LOCKED
    end

    def sold?
      state == STATE_SOLD
    end
  end
end
