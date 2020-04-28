class Common::FeelingType < ApplicationRecord
  self.table_name = 'feeling_types'
  has_one_attached :icon
end
