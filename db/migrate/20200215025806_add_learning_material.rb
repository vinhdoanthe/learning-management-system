class AddLearningMaterial < ActiveRecord::Migration[6.0]
  def up
    create_table :learning_materials do |t|
      t.string :title
      t.text :description
      t.string :material_type
      t.string :learning_type
      t.references :op_lession, index: true, foreign_key: {to_table: 'op_lession'}

      t.timestamps
    end
  end

  def down
    drop_table(:learning_materials, if_exists: true)
  end
end