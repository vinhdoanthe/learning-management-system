module Redeem
  class RedeemProduct < ApplicationRecord
    self.table_name = 'redeem_products'

    serialize :available_color, Array
    serialize :available_size, Array

    has_many :redeem_transactions
    has_many_attached :images
  end
end
