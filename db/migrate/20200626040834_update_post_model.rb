class UpdatePostModel < ActiveRecord::Migration[6.0]
  def change
    # add soft-delete columns to Post model
    add_column :sc_posts, :discarded_at, :datetime
    add_index :sc_posts, :discarded_at

    # add new tables for UserCustomPostContent, UserSharedPhoto model
    create_table :user_custom_post_contents do |t|
      t.text :content

      t.timestamps
    end 

    create_table :user_shared_photos do |t|
      t.string :image
      
      t.references :user_custom_post_content, index: true
      t.timestamps
    end
  end
end
