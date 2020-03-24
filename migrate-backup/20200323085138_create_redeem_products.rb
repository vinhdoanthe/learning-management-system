class CreateRedeemProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :redeem_products do |t|
      t.string :name, null: false ,limit: 255
      t.decimal :price, precision: 10, scale: 2
      t.integer :category, null: false,limit: 4
      t.string :available_color, null: true ,limit: 255
      t.string :available_size, null: true , limit: 255
      t.string :brand, null: true ,limit: 255

      t.timestamps
    end
    add_index :redeem_products, :name
    add_index :redeem_products, :category
  end
end
