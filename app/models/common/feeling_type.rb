class Common::FeelingType < ApplicationRecord
  self.table_name = 'feeling_types'
  has_one_attached :icon

  rails_admin do
    list do
      field :name
      field :icon
    end

    show do
      field :name
      field :icon
    end

    edit do
      field :name
      field :icon
    end
  end
end
