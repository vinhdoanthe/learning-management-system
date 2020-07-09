class CreatePictureModel < ActiveRecord::Migration[6.0]
  def change
    create_table :sc_pictures do |t|
      t.string :avatar
      t.timestamps
    end
  end
end
