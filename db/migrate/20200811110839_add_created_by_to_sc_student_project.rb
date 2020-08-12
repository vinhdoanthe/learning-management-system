class AddCreatedByToScStudentProject < ActiveRecord::Migration[6.0]
  def change
    add_column :sc_student_projects, :created_by, :integer
  end
end
