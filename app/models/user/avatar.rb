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

  def self.get_avatars_by_gender(gender=nil)
    if !gender.nil?
      avatars = User::Avatar.where(gender: gender).to_a
    else
      avatars = User::Avatar.all.to_a
    end

    avatars
    # avatar_links = []
    # avatars.each do |avatar|
    #   if avatar.thumbnail.attached? and avatar.full_size.attached?
    #     avatar_obj = {
    #       'thumbnail' => avatar.thumbnail,
    #       'full_size' => avatar.full_size
    #     }
    #     avatar_links << avatar_obj
    #   end
    # end
    # avatar_links
  end
end
