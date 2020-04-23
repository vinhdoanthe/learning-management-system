class Common::RewardType < ApplicationRecord
  self.table_name = 'reward_types'
  has_one_attached :icon
end
