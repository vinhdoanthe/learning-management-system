class CreateRedeemTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :redeem_transactions do |t|
      t.integer :student_id, null: false,limit: 8
      t.integer :redeem_product_id, null: false,limit: 8
      t.string :color, null: false,limit: 255
      t.integer :size, limit: 4
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :total_paid, precision: 10, scale: 2
      t.integer :status, limit: 4

      t.timestamps
    end
    add_index :redeem_transactions, :student_id
    add_index :redeem_transactions, :redeem_product_id
  end
end
