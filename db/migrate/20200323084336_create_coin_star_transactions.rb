class CreateCoinStarTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :coin_star_transactions do |t|
      t.integer :give_to, limit: 8
      t.integer :give_by, limit: 8
      t.integer :activity_id, limit: 8
      t.string :activity_type, limit: 10

      t.timestamps
    end
    add_index :coin_star_transactions, :give_to
    add_index :coin_star_transactions, :give_by
    add_index :coin_star_transactions, :activity_id
    add_index :coin_star_transactions, :activity_type
  end
end
