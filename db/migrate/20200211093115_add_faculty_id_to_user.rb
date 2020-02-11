class AddFacultyIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :faculty_id, :integer
  end
end
