class CreateFaqQuestionTable < ActiveRecord::Migration[6.0]
  def change
    create_table :faq_questions do |t|
      t.string :content
      t.integer :created_by
      t.boolean :active

      t.timestamps
    end
  end
end
