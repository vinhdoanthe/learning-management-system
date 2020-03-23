class CreateCoinStarTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :coin_star_transactions do |t|
      t.int :give_to
      t.int :give_by
      t.int :activity_id
      t.string :activity_type, limit: 30

      t.timestamps
    end
  end
end
