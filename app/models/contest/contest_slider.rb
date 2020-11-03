class Contest::ContestSlider < ApplicationRecord
  self.table_name = 'tk_contest_sliders'

  has_one_attached :image
  has_one_attached :logo
  has_one_attached :thumbnail
end
