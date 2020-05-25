module User
  module Reward
    class CoinStarTransaction
      include Mongoid::Document
      include Mongoid::Timestamps

      field :transaction_type, type: String
      field :amount, type: Integer
      field :give_to, type: Integer
      field :give_by, type: Integer
    end
  end
end
