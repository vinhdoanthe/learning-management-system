class AddAdminNoteToRedeemTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column :redeem_transactions, :admin_note, :text
  end
end
