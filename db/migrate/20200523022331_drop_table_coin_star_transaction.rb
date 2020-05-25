class DropTableCoinStarTransaction < ActiveRecord::Migration[6.0]
  def change
    drop_table :coin_star_transactions
  end
end
