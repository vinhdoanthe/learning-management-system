module User
  module Reward
    class CoinStarTransaction
      include Mongoid::Document
      include Mongoid::Timestamps

      field :transaction_type, type: String
      field :amount, type: Integer
      field :give_to, type: Integer
      field :give_by, type: Integer
      field :coinstarable_id, type: Integer
      field :coinstarable_type, type: String

      def coinstarable
        coinstarable_type.constantize.find(coinstarable_id)
      end

      def coinstarable=(input)
         self.coinstarable_type = input.class #STI makes this more complicated we must store the base class
         self.coinstarable_id = input.id
      end
    end
  end
end
