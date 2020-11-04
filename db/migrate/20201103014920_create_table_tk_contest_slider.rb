class CreateTableTkContestSlider < ActiveRecord::Migration[6.0]
  def up
    create_table :tk_contest_sliders do |t|
      t.boolean :is_publish
      t.string :title
      t.string :image_side

      t.timestamps
    end
  end

  def down
    drop_table('tk_contest_sliders', if_exists: true)
  end
end
