class UpdateLearningMaterialModel < ActiveRecord::Migration[6.0]
  def up
    add_column :learning_materials, :google_drive_link, :string
    add_column :learning_materials, :ziggeo_file_id, :string
  end

  def down
    remove_column :learning_materials, :google_drive_link if column_exists?(:learning_materials, :google_drive_link)
    remove_column :learning_materials, :ziggeo_file_id if column_exists?(:learning_materials, :ziggeo_file_id)
  end
end
