class User::Avatar < ApplicationRecord

  extend Enumerize
  include Constant

  enumerize :gender, in: [Constant::Gender::MALE, Constant::Gender::FEMALE]
  has_one_attached :thumbnail
  has_one_attached :full_size

  rails_admin do
    list do
      field :gender
    end

    show do
      field :gender
      field :thumbnail
      field :full_size
    end

    edit do
      field :gender
      field :thumbnail
      field :full_size
    end 
  end 
end
