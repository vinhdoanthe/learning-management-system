class Contest::ContestEvent < ApplicationRecord
  self.table_name = 'tk_contest_events'

  has_one_attached :thumbnail
end
