class RemovePresentationFromScStudentProject < ActiveRecord::Migration[6.0]
  def up
    remove_column :sc_student_projects, :presentation
  end

  def down
    add_column :sc_student_projects, :presentation, :string
  end
end
