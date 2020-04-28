class AddDashboardModels < ActiveRecord::Migration[6.0]
  def change
    create_table :albums do |t|
      t.bigint :batch_id, index: true
      t.timestamps
    end
    add_foreign_key :albums, :op_batch, column: :batch_id

    create_table :photos do |t|
      t.bigint :album_id, index: true
      t.bigint :session_id, index: true
      t.bigint :created_by
      t.timestamps
    end
    add_foreign_key :photos, :albums, column: :album_id
    add_foreign_key :photos, :op_session, column: :session_id
    add_foreign_key :photos, :users, column: :created_by

    remove_column :comments, :user_id if column_exists?(:comments, :user_id)
    remove_column :comments, :post_id if column_exists?(:comments, :post_id)
    remove_column :comments, :post_type if column_exists?(:comments, :post_type)
    remove_column :comments, :parent_comment_id if column_exists?(:comments, :parent_comment_id)
    add_column :comments, :commented_by, :bigint
    add_foreign_key :comments, :users, column: :commented_by
    add_reference :comments, :commentable, polymorphic: true
    add_timestamps :comments

    remove_column :reactions, :user_id if column_exists?(:reactions, :user_id)
    remove_column :reactions, :post_id if column_exists?(:reactions, :post_id)
    remove_column :reactions, :post_type if column_exists?(:reactions, :post_type)
    rename_column :reactions, :type, :react_type
    add_column :reactions, :reacted_by, :bigint
    add_foreign_key :reactions, :users, column: :reacted_by
    add_reference :reactions, :reactable, polymorphic: true

    create_table :session_student_rewards do |t|
      t.bigint :session_id, index: true
      t.bigint :rewarded_by, index: true
      t.bigint :rewarded_to, index: true
      t.integer :reward_type_id, limit: 1, index: true
      t.timestamps
    end
    add_foreign_key :session_student_rewards, :op_session, column: :session_id
    add_foreign_key :session_student_rewards, :users, column: :rewarded_by
    add_foreign_key :session_student_rewards, :users, column: :rewarded_to

    create_table :reward_types do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
    add_foreign_key :session_student_rewards, :reward_types, column: :reward_type_id

    create_table :session_student_feedbacks do |t|
      t.bigint :session_id, index: true
      t.bigint :feedback_by, index: true
      t.integer :feeling_type_id, limit: 1, index: true
      t.text :content
      t.timestamps
    end

    create_table :feeling_types do |t|
      t.string :name
      t.timestamps
    end

    add_foreign_key :session_student_feedbacks, :op_session, column: :session_id
    add_foreign_key :session_student_feedbacks, :users, column: :feedback_by
    add_foreign_key :session_student_feedbacks, :feeling_types, column: :feeling_type_id

    create_table :conversations do |t|
      t.bigint :batch_id, index: true
      t.integer :conversation_type, limit: 1
      t.bigint :created_by
      t.timestamps
    end

    create_table :messages do |t|
      t.bigint :conversation_id
      t.text :content
      t.bigint :sent_by
      t.timestamps
    end

    add_foreign_key :messages, :conversations, column: :conversation_id
    add_foreign_key :messages, :users, column: :sent_by
    add_foreign_key :conversations, :op_batch, column: :batch_id
    add_foreign_key :conversations, :users, column: :created_by
  end
end
