module Redeem
  class RedeemProductCategory < ApplicationRecord
    self.table_name = 'redeem_product_categories'

    has_many :redeem_products
  end
end
