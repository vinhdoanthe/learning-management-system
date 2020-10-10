class CreateTableTkContestCriterions < ActiveRecord::Migration[6.0]
  def up
    create_table :tk_contest_criterions do |t|
      t.integer :contest_topic_id
      t.text :description
      t.text :name
      t.integer :point

      t.timestamps
    end
  end

  def down
    drop_table(:tk_contest_criterions, if_exists: true)
  end
end
