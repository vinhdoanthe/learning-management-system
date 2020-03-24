class UpdateCoinStarRedeemComment < ActiveRecord::Migration[6.0]
  def change
    add_reference :comments, :user_id, foreign_key: {to_table: :users} unless foreign_key_exists?(:comments, :user_id)
    add_column :comments, :post_id, :integer, limit: 8 unless column_exists?(:comments, :post_id)
    add_index :comments, :post_id unless index_exists?(:comments, :post_id)
    add_column :comments, :post_type, :string, limit: 50 unless column_exists?(:comments, :post_type)
    add_column :comments, :parent_comment_id, :integer, limit: 8 unless column_exists?(:comments, :parent_comment_id)
    add_index :comments, :parent_comment_id unless index_exists?(:comments, :parent_comment_id)
  end
end
