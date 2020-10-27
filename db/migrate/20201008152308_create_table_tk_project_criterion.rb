class CreateTableTkProjectCriterion < ActiveRecord::Migration[6.0]
  def up
    create_table :tk_project_criterions do |t|
      t.integer :contest_project_id
      t.integer :contest_criterion_id
      t.integer :number
      t.integer :point_exchange

      t.timestamps
    end
  end

  def down
    drop_table('tk_project_criterions', if_exists: true)
  end
end
