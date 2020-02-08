module User
  class UserNotification < ApplicationRecord
    belongs_to :user
  end
end