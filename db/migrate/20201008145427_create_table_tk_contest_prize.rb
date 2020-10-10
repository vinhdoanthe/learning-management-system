class CreateTableTkContestPrize < ActiveRecord::Migration[6.0]
  def up
    create_table :tk_contest_prizes do |t|
      t.integer :contest_id
      t.string :name, limit: 256
      t.string :description, limit: 256
      t.string :month_active
      t.integer :student_price
      t.integer :teacher_price
      t.integer :prize
      t.string :prize_type
      t.integer :number_awards

      t.timestamps
    end
  end

  def down
    drop_table("tk_contest_prizes", if_exists: true)
  end
end
