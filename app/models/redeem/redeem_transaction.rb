module Redeem
  class RedeemTransaction < ApplicationRecord
    self.table_name = 'redeem_transactions'

    belongs_to :redeem_product
    belongs_to :user, class_name: 'User::Account::User', foreign_key: 'student_id'
  end
end
