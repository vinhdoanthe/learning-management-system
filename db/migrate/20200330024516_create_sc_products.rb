class CreateScProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :sc_products do |t|
      t.text :description
      t.text :presentation
      t.text :video
      t.text :thumbnail
      t.integer :batch_id
      t.integer :user_id
      t.integer :course_id
      t.integer :student_id

      t.timestamps
    end
  end
end
