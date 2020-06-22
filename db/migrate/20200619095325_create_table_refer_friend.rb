class CreateTableReferFriend < ActiveRecord::Migration[6.0]
  def up
    create_table :refer_friends do |t|
      t.string :code
      t.string :student_name
      t.string :parent_name
      t.string :email
      t.string :mobile
      t.text :note
      t.string :state
      t.integer :refer_by

      t.timestamps
    end
    
    add_foreign_key :refer_friends, :users, column: 'refer_by'
  end

  def down
    drop_table :refer_friends do |t|
      t.string :code
      t.string :student_name
      t.string :parent_name
      t.string :email
      t.string :mobile
      t.text :note
      t.string :state
      t.integer :refer_by
    end

    t.timestamps
  end
end
