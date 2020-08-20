class AddCodeToRedeemProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :redeem_products, :code, :string
  end
end
