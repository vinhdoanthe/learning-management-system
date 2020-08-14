class UpdateRedeemTables < ActiveRecord::Migration[6.0]
  def change
    
    # add new tables
    # redeem_product_brands
    create_table :redeem_product_brands do |t|
      t.string :name
      t.timestamps
    end

    # redeem_product_items
    create_table :redeem_product_items do |t|
      t.integer :product_id, index: true
      t.integer :company_id, index: true
      t.integer :size_id, index: true
      t.integer :color_id, index: true
      t.integer :transaction_id, index: true
      t.string :item_code
      t.string :state
      t.datetime :input_date
      t.datetime :release_date
      t.timestamps
    end

    # redeem_product_sizes
    create_table :redeem_product_sizes do |t|
      t.string :name
      t.timestamps
    end

    # redeem_product_colors
    create_table :redeem_product_colors do |t|
      t.string :name
      t.string :color_code
      t.timestamps
    end
   
    # update redeem_products model 
    remove_column :redeem_products, :available_color, :string
    remove_column :redeem_products, :available_size, :integer
    remove_column :redeem_products, :category, :string
    remove_column :redeem_products, :brand, :string
    add_column :redeem_products, :category_id, :integer, index: true
    add_column :redeem_products, :brand_id, :integer, index: true
    
    # update redeem_transactions table
    rename_column :redeem_transactions, :redeem_product_id, :product_id
    rename_column :redeem_transactions, :company_id, :delivery_company_id
    rename_column :redeem_transactions, :expected_time, :student_delivery_date
    remove_column :redeem_transactions, :color, :integer
    add_column :redeem_transactions, :color_id, :integer, index: true
    remove_column :redeem_transactions, :size, :string
    add_column :redeem_transactions, :size_id, :integer, index: true
    add_column :redeem_transactions, :operator_delivery_date, :datetime
    add_column :redeem_transactions, :actual_delivery_date, :datetime

    # add foreign_key
    # redeem_products
    add_foreign_key :redeem_products, :redeem_product_categories, column: :category_id
    add_foreign_key :redeem_products, :redeem_product_brands, column: :brand_id
    # redeem_product_items
    add_foreign_key :redeem_product_items, :redeem_products, column: :product_id
    add_foreign_key :redeem_product_items, :res_company, column: :company_id, require: false
    add_foreign_key :redeem_product_items, :redeem_product_colors, column: :color_id
    add_foreign_key :redeem_product_items, :redeem_product_sizes, column: :size_id
    add_foreign_key :redeem_product_items, :redeem_transactions, column: :transaction_id, require: false
    # redeem_transactions
    add_foreign_key :redeem_transactions, :redeem_product_sizes, column: :size_id
    add_foreign_key :redeem_transactions, :redeem_product_colors, column: :color_id

  end
end
