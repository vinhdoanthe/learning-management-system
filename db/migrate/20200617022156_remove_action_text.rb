class RemoveActionText < ActiveRecord::Migration[6.0]
  def change
    drop_table :action_text_rich_texts if table_exists?(:action_text_rich_texts)
  end
end
