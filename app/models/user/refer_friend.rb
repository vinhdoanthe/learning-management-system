module User
  class ReferFriend < ApplicationRecord
    belongs_to :user
  end
end