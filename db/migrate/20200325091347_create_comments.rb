class CreateComments < ActiveRecord::Migration[6.0]
  def change
    #drop_table(:comments, if_exists: true)
    create_table :comments, comment: 'table comment ve mot noi dung cua nguoi dung' , if_not_exists: true do |t|
      t.references :user, null: false, index: true
      t.foreign_key :comments, column: :user_id, name: "comments_user_id_fkey"
      t.integer :post_id, limit: 8, null:false, comment: "id cua noi dung comment"
      t.string :post_type, limit: 10, null:true, comment: "loai noi dung comment: batch; album; photo;lesson"
      t.integer :parent_comment_id, limit: 8, null: true, comment: "id comment cha"
      t.text :content, null: true, comment: "noi dung comment"
    end
    add_index :comments, :post_id unless index_exists?(:comments, :post_id)
    add_index :comments, :parent_comment_id unless index_exists?(:comments, :parent_comment_id)
  end
end
