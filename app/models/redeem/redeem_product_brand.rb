module Redeem
  class RedeemProductBrand < ApplicationRecord
    self.table_name = 'redeem_product_brands'

    has_many :redeem_products, class_name: 'Redeem::RedeemProduct', foreign_key: 'brand_id'
  end
end
