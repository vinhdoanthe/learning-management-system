class AddColumnToComment < ActiveRecord::Migration[6.0]
  def change
    add_reference :comments, :user, null: false, foreign_key: true
    add_column :comments, :post_id, :integer, limit: 8
    add_index :comments, :post_id
    add_column :comments, :post_type, :string, limit: 50
    add_column :comments, :parent_comment_id, :integer, limit: 8
    add_index :comments, :parent_comment_id
  end
end
