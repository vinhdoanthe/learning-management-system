class UpdateScProductTable < ActiveRecord::Migration[6.0]
  def change
    rename_table :sc_products, :sc_student_projects
    rename_column :sc_student_projects, :video, :project_show_video
    add_column :sc_student_projects, :introduction_video, :string
    add_column :sc_student_projects, :subject_id, :integer, index: true
    add_foreign_key :sc_student_projects, :op_subject, column: 'subject_id'
    add_reference :sc_student_projects, :sc_post, foreign_key: true
  end
end
