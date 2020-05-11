class AddCompanyTimeToRedeemTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column :redeem_transactions, :company_id, :integer
    add_column :redeem_transactions, :expected_time, :datetime
  end
end
