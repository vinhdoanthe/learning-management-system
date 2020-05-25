module User
  module Reward
    class TekyCoinStarActivitySetting
      include Mongoid::Document
      include Mongoid::Timestamps

      field :setting_key, type: String
      index({ setting_key: 1 }, { unique: true, name: "setting_key_index" })
      field :description, type: String
      field :is_add_coin, type: Boolean
      field :is_add_star, type: Boolean
      field :coin, type: Integer
      field :star, type: Integer
      field :created_by, type: Integer
      field :updated_by, type: Integer
    end
  end
end
