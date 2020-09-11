class AddProjectTypeToScStudentProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :sc_student_projects, :project_type, :string
  end
end
