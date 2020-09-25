module Redeem
  class RedeemProduct < ApplicationRecord
    self.table_name = 'redeem_products'
   
    belongs_to :redeem_product_brand, class_name: 'Redeem::RedeemProductBrand', foreign_key: 'brand_id'
    belongs_to :redeem_product_category, class_name: 'Redeem::RedeemProductCategory', foreign_key: 'category_id'

    has_many :redeem_product_items, class_name: 'Redeem::RedeemProductItem', foreign_key: 'product_id'
    has_many :redeem_transactions, class_name: 'Redeem::RedeemTransaction', foreign_key: 'product_id'
    has_many_attached :images

    validates :code, uniqueness: true

  end
end
