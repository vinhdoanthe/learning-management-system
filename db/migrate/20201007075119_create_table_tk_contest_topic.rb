class CreateTableTkContestTopic < ActiveRecord::Migration[6.0]
  def up
    create_table :tk_contest_topics do |t|
      t.integer :contest_id
      t.string :name
      t.string :description
      t.string :rule
      t.string :region
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end

  def down
    drop_table("tk_contest_topics", if_exists: true)
  end
end
