class AddColumnToScStudentProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :sc_student_projects, :state, :string
    add_column :sc_student_projects, :permission, :string
  end
end
