class CreateTableTkContestEvent < ActiveRecord::Migration[6.0]
  def up
    create_table :tk_contest_events do |t|
      t.string :name
      t.string :link

      t.timestamps
    end
  end

  def down
    drop_table('tk_contest_events', if_exists: true)
  end
end
