class CreatePostTable < ActiveRecord::Migration[6.0]
  def change
    create_table :sc_posts do |t|
      t.string :type
      t.integer :posted_by

      t.timestamps
    end

    add_foreign_key :sc_posts, :users, column: 'posted_by'
    add_reference :photos, :sc_post, foreign_key: true
    add_reference :session_student_rewards, :sc_post, foreign_key: true
  end
end
