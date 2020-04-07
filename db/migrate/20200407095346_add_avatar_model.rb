class AddAvatarModel < ActiveRecord::Migration[6.0]
  def change
    create_table :avatars do |t|
      t.string :gender

      t.timestamps
    end

    add_reference :users, :avatar, index: true
  end
end
