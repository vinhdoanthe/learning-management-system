class AddInformationFieldsToOpCourse < ActiveRecord::Migration[6.0]
  def change
    add_column :op_course, :equipments, :string
    add_column :op_course, :prerequisites, :string
    add_column :op_course, :competences, :text
  end
end
