class AddGoogleDriveFileIdToLearningMaterial < ActiveRecord::Migration[6.0]
  def up
    add_column :learning_materials, :google_drive_file_id, :string
  end

  def down
    remove_column :learning_materials, :google_drive_file_id if column_exists?(:learning_materials, :google_drive_file_id)
  end
end
