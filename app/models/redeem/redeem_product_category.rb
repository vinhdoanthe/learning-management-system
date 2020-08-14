module Redeem
  class RedeemProductCategory < ApplicationRecord
    self.table_name = 'redeem_product_categories'

    has_many :redeem_products, class_name: 'Redeem::RedeemProduct', foreign_key: 'category_id'
  end
end
