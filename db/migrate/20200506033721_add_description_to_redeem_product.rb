class AddDescriptionToRedeemProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :redeem_products, :description, :text
  end
end
