module User
  class User < ApplicationRecord
    has_many :refer_friends
    has_many :coin_star_transactions
    has_many :redeem_transactions
    has_many :user_notifications

    belongs_to :op_student
    belongs_to :op_parent
  end
end