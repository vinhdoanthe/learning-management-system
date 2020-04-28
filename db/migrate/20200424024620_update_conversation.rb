class UpdateConversation < ActiveRecord::Migration[6.0]

  def change
    remove_foreign_key :messages, :conversations, column: :conversation_id if foreign_key_exists?(:messages, :conversations, column: :conversation_id)
    remove_column :messages, :conversation_id if column_exists?(:messages, :conversation_id)
    add_reference :messages, :messageable, polymorphic: true

    create_table :discussions do |t|
      t.bigint :batch_id
      t.timestamps
    end

    add_foreign_key :discussions, :op_batch, column: :batch_id
  end

end
