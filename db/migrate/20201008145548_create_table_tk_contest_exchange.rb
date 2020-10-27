class CreateTableTkContestExchange < ActiveRecord::Migration[6.0]
  def up
    create_table :tk_contest_exchanges do |t|
      t.string :title, limit: 256
      t.integer :top_from
      t.integer :top_end
      t.integer :point

      t.timestamps
    end
  end

  def down
    drop_table("tk_contest_exchanges", if_exists: true)
  end
end
