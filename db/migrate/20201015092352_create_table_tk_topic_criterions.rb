class CreateTableTkTopicCriterions < ActiveRecord::Migration[6.0]
  def change
    create_table :tk_topic_criterions do |t|
      t.integer :contest_topic_id
      t.integer :contest_criterion_id

      t.timestamps
    end
  end
end
