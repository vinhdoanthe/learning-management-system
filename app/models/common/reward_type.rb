class Common::RewardType < ApplicationRecord
  self.table_name = 'reward_types'
  has_one_attached :icon

  rails_admin do
    list do
      field :name
    end

    show do
      field :name
      field :description
      field :icon
    end

    edit do
      field :name
      field :description
      field :icon
    end
  end 
end
