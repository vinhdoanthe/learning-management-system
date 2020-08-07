class CreateFaqAnswerTable < ActiveRecord::Migration[6.0]
  def change
    create_table :faq_answers do |t|
      t.string :content
      t.integer :created_by

      t.timestamps

      t.references :faq_questions, foreign_key: true
    end
  end
end
