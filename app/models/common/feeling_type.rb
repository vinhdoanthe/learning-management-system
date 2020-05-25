class Common::FeelingType < ApplicationRecord
  self.table_name = 'feeling_types'
  has_one_attached :icon

  rails_admin do
    list do

    end

    show do

    end

    edit do

    end
  end
end
