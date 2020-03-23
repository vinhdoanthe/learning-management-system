class CreateReactions < ActiveRecord::Migration[6.0]
  def change
    create_table :reactions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :type, null: false
      t.integer :post_id, null: false, limit: 8
      t.string :post_type, limit: 10

      t.timestamps
    end
    add_index :reactions, :post_id
    add_index :reactions, :post_type
  end
end
