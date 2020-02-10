module User
  class RedeemTransaction < ApplicationRecord
    belongs_to :user
  end
end