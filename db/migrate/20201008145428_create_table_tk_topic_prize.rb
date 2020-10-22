class CreateTableTkTopicPrize < ActiveRecord::Migration[6.0]
  def up
    create_table :tk_topic_prizes do |t|
      t.integer :contest_topic_id
      t.integer :contest_prize_id

      t.timestamps
    end
  end

  def down
    drop_table("tk_topic_prizes", if_exists: true)
  end
end
