class AddCourseDescriptionModel < ActiveRecord::Migration[6.0]
  def up
    create_table :course_description do |t|
      t.references :op_course, index: true, foreign_key: {to_table: :op_course}
      t.text :description
    
      t.timestamps
    end
  end

  def down
    drop_table :course_description if table_exists?(:course_description)
  end
end
