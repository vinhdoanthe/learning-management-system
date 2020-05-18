module User
  module Reward
    class CoinStarTransaction < ApplicationRecord
      belongs_to :user
    end
  end
end
