class CreateStudentProjectPlaylistTable < ActiveRecord::Migration[6.0]
  def change
    create_table :student_project_playlists do |t|
      t.integer :batch_id
      t.string :playlist_id

      t.timestamps
    end
  end
end
