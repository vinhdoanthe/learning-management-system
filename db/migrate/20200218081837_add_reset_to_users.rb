class AddResetToUsers < ActiveRecord::Migration[6.0]
  def up
    rename_column :users, :reset_password_token, :reset_digest
    rename_column :users, :password_token_reset_time, :reset_sent_at
  end

  def down
    rename_column :users, :reset_digest, :reset_password_token
    rename_column :users, :reset_sent_at, :password_token_reset_time
  end
end
