module User
  class CoinStarTransaction < ApplicationRecord
    belongs_to :user
  end
end