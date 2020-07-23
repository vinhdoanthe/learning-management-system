class UpdateUserCustomPostModels < ActiveRecord::Migration[6.0]
  def change
    drop_table :user_shared_photos if table_exists?(:user_shared_photos)
  end
end
