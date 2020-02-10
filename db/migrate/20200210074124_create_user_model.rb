class CreateUserModel < ActiveRecord::Migration[6.0]
  def up
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :account_role, index: true
      t.boolean :status
      t.integer :parent_account_id
      t.integer :parent_id
      t.integer :student_id
      t.integer :star
      t.integer :coin
      t.string :reset_password_token
      t.timestamp :password_token_reset_time
      t.timestamps
    end
  end

  def down
    drop_table(:users, if_exists: true)
  end
end
