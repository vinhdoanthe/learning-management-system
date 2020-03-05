class CreateQuizModules < ActiveRecord::Migration[6.0]
  def up
    create_table :questions do |table|
      table.references :op_lession, index: true, foreign_key: {to_table: :op_lession}
      table.text :question
      table.string :question_type
      table.boolean :is_active

      table.timestamps
    end

    create_table :question_choices do |table|
      table.references :question, foreign_key: true
      table.boolean :is_right_choice
      table.string :choice_content

      table.timestamps
    end

    create_table :user_questions do |table|
      table.references :student, index: true,  foreign_key: {to_table: :users}
      table.references :question, foreign_key: true
      table.references :op_batch, index: true, foreign_key: {to_table: :op_batch}, null: true

      table.timestamps
    end

    create_table :user_answers do |table|
      table.references :user_question, foreign_key: true
      table.references :question_choice, foreign_key: true
      table.text :answer_content
      table.string :state
      table.timestamp :answer_time

      table.timestamps
    end

    create_table :answer_marks do |table|
      table.references :user_answer, foreign_key: true
      table.text :mark_content
      table.boolean :answer_is_right
      table.references :teacher, index: true, foreign: {to_table: :users}
      table.timestamp :mark_time

      table.timestamps
    end

  end

  def down
    drop_table(:answer_marks, if_exists: true)
    drop_table(:user_answers, if_exists: true)
    drop_table(:user_questions, if_exists: true)
    drop_table(:question_choices, if_exists: true)
    drop_table(:questions, if_exists: true)
  end
end
