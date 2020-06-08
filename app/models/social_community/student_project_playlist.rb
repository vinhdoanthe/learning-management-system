class SocialCommunity::StudentProjectPlaylist < ApplicationRecord
  self.table_name = 'student_project_playlists'

  belongs_to :op_batch, class_name: 'Learning::Batch::OpBatch', foreign_key: 'batch_id'
end
