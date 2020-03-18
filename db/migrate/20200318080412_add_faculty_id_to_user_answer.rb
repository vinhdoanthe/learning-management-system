class AddFacultyIdToUserAnswer < ActiveRecord::Migration[6.0]
  def change
    add_column :user_answers, :faculty_id, :string
    add_column :user_answers, :integer, :string
  end
end
