class CreateTableTkContests < ActiveRecord::Migration[6.0]
  def up
    create_table :tk_contests do |t|
      t.string :name
      t.string :description
      t.boolean :is_publish

      t.timestamps
    end
  end

  def down
    drop_table(:tk_contests, if_exists: true)
  end
end
