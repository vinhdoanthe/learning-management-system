class AddContentTypeToLearningMaterial < ActiveRecord::Migration[6.0]
  def change
    add_column :learning_materials, :content_type, :string
  end
end
