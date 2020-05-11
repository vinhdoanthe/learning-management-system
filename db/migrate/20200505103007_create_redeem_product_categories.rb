class CreateRedeemProductCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :redeem_product_categories do |t|
      t.string :name
      t.timestamps
    end
  end
end
