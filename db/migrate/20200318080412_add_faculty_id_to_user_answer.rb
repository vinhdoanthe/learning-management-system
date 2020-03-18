class AddFacultyIdToUserAnswer < ActiveRecord::Migration[6.0]
  def up
    add_reference :user_answers, :faculty, foreign_key: {to_table: :op_faculty}
  end

  def down
    remove_column :user_answers, :faculty_id if column_exists?(:user_answers, :faculty_id)
  end
end
