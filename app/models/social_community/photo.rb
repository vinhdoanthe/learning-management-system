class SocialCommunity::Photo < ApplicationRecord
  self.table_name = 'photos'

  belongs_to :op_session, class_name: 'Learning::Batch::OpSession', foreign_key: 'session_id'
  has_one_attached :image
end
