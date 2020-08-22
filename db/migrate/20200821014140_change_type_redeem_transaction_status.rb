class ChangeTypeRedeemTransactionStatus < ActiveRecord::Migration[6.0]
  def change
    change_column :redeem_transactions, :status, :string
  end
end
