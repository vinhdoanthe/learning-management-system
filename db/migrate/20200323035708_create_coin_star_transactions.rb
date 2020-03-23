class CreateCoinStarTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :coin_star_transactions do |t|
      t.integer :give_to
      t.integer :give_by
      t.integer :activity_id
      t.string :activity_type, limit: 30

      t.timestamps
    end
  end
end
