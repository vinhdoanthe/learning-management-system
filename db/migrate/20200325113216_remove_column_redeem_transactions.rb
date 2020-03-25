class RemoveColumnRedeemTransactions < ActiveRecord::Migration[6.0]
  def change
  	remove_column :redeem_transactions, :student_id_id if column_exists?(:redeem_transactions, :student_id_id)
  	remove_column :redeem_transactions, :redeem_product_id_id if column_exists?(:redeem_transactions, :redeem_product_id_id)
  end
end
