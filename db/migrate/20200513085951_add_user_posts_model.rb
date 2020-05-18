class AddUserPostsModel < ActiveRecord::Migration[6.0]
  def change
    create_table :user_posts do |t|
      t.references :user, index: true
      t.references :sc_post, index: true
      t.timestamps
    end
  end
end
