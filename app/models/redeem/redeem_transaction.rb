module Redeem
  class RedeemTransaction < ApplicationRecord
    self.table_name = 'redeem_transactions'
    extend Enumerize

    enumerize :status, in: RedeemConstants::TransactionState::REDEEM_TRANSACTION_STATES

    belongs_to :redeem_product, class_name: 'Redeem::RedeemProduct', foreign_key: 'product_id'
    belongs_to :user, class_name: 'User::Account::User', foreign_key: 'student_id'
    belongs_to :redeem_product_size, class_name: 'Redeem::RedeemProductSize', foreign_key: 'size_id'
    belongs_to :redeem_product_color, class_name: 'Redeem::RedeemProductColor', foreign_key: 'color_id'
    belongs_to :res_company, class_name: 'Common::ResCompany', foreign_key: 'company_id', required: false
    has_many :redeem_product_items, class_name: 'Redeem::RedeemProductItem', foreign_key: 'transaction_id'
    has_one :post_activity, class_name: 'SocialCommunity::Feed::PostActivity', as: :activitiable

    
    ## check transaction status
    def status_new?
      status == RedeemConstants::TransactionState::REDEEM_TRANSACTION_STATE_NEW
    end

    ## check transaction status
    def status_ready?
      status == RedeemConstants::TransactionState::REDEEM_TRANSACTION_STATE_READY
    end

    ## check transaction status
    def status_cancel?
      status == RedeemConstants::TransactionState::REDEEM_TRANSACTION_STATE_CANCEL
    end
    
    ## check transaction status
    def status_done?
      status == RedeemConstants::TransactionState::REDEEM_TRANSACTION_STATE_DONE
    end
  end
end
