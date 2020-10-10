class CreateTableTkContestProject < ActiveRecord::Migration[6.0]
  def up
    create_table :tk_contest_projects do |t|
      t.integer :project_id
      t.integer :contest_id
      t.integer :contest_topic_id
      t.integer :contest_prize_id
      t.integer :user_id
      t.integer :views
      t.integer :score
      t.boolean :valid

      t.timestamps
    end
  end

  def down
    drop_table("tk_contest_projects", if_exists: true)
  end
end
