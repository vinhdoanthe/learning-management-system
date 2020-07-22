class AddFieldsToOpCourse < ActiveRecord::Migration[6.0]
  def change
    add_column :op_course, :short_description, :text
    add_column :op_course, :suitable_age, :string
    add_column :op_course, :duration, :string
    create_table :public_courses do |t|
      t.integer :course_id, index: true
    end
    add_foreign_key :public_courses, :op_course, :column => :course_id
  end
end
