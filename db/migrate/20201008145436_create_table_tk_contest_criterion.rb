class CreateTableTkContestCriterion < ActiveRecord::Migration[6.0]
  def up
    create_table :tk_contest_criterions do |t|
      t.string :name, limit: 150
      t.integer :point
      t.string :description, limit: 256

      t.timestamps
    end
  end

  def down
    drop_table('tk_contest_criterions', if_exists: true)
  end
end
