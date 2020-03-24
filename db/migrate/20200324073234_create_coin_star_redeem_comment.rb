class CreateCoinStarRedeemComment < ActiveRecord::Migration[6.0]
  def change
    
    create_table :redeem_products, if_not_exists: true do |t|
      t.string :name, null: false ,limit: 255
      t.decimal :price, precision: 10, scale: 2
      t.integer :category, null: false,limit: 4
      t.string :available_color, null: true ,limit: 255
      t.string :available_size, null: true , limit: 255
      t.string :brand, null: true ,limit: 255

      t.timestamps
    end

    add_index :redeem_products, :name unless index_exists?(:redeem_products, :name)
    add_index :redeem_products, :category unless index_exists?(:redeem_products, :category)
    
    create_table :coin_star_transactions, if_not_exists: true do |t|
      t.integer :give_to, limit: 8
      t.integer :give_by, limit: 8
      t.integer :activity_id, limit: 8
      t.string :activity_type, limit: 10

      t.timestamps
    end

    add_index :coin_star_transactions, :give_to unless index_exists?(:coin_star_transactions, :give_to)
    add_index :coin_star_transactions, :give_by unless index_exists?(:coin_star_transactions, :give_by)
    add_index :coin_star_transactions, :activity_id unless index_exists?(:coin_star_transactions, :activity_id)
    add_index :coin_star_transactions, :activity_type unless index_exists?(:coin_star_transactions, :activity_type)
    
    # table mua vat Pham
    create_table :redeem_transactions, if_not_exists: true do |t|
      t.integer :student_id, null: false,limit: 8
      t.integer :redeem_product_id, null: false,limit: 8
      t.string :color, null: false,limit: 255
      t.integer :size, limit: 4
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :total_paid, precision: 10, scale: 2
      t.integer :status, limit: 4

      t.timestamps
    end

    add_index :redeem_transactions, :student_id unless index_exists?(:redeem_transactions, :student_id)
    add_reference :redeem_transactions, :student_id, foreign_key: {to_table: :op_student} unless foreign_key_exists?(:redeem_transactions, :student_id)

    add_index :redeem_transactions, :redeem_product_id unless index_exists?(:redeem_transactions, :redeem_product_id)
    add_reference :redeem_transactions, :redeem_product_id, foreign_key: {to_table: :redeem_products} unless foreign_key_exists?(:redeem_transactions, :redeem_product_id)

    create_table :reactions, if_not_exists: true do |t|
      #t.references :user, null: false, foreign_key: true
      t.integer :user_id, null: false, limit: 8
      t.integer :type, null: false
      t.integer :post_id, null: false, limit: 8
      t.string :post_type, limit: 10

      t.timestamps
    end

    add_reference :reactions, :user_id, foreign_key: {to_table: :users} unless foreign_key_exists?(:reactions, :user_id)
    add_index :reactions, :post_id unless index_exists?(:reactions, :post_id)
    add_index :reactions, :post_type unless index_exists?(:reactions, :post_type)

  end
end
