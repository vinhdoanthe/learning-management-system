class User::Account::Avatar < ApplicationRecord

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

  def self.get_avatars_by_gender(gender=nil)
    if !gender.nil?
      avatars = User::Account::Avatar.where(gender: gender).to_a
    else
      avatars = User::Account::Avatar.all.to_a
    end

    avatars
  end
end
