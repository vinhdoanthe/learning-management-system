class SocialCommunity::Picture < ApplicationRecord
  require 'carrierwave/orm/activerecord'

  self.table_name = 'sc_pictures'
  include Rails.application.routes.url_helpers
  mount_uploader :avatar, ImageUploader


  def to_jq_upload
    {
      "name" => read_attribute(:avatar),
      "size" => avatar.size,
      "url" => avatar.url,
      "thumbnail_url" => avatar.thumb.url,
      "delete_url" => social_community_picture_path(:id => id),
      "delete_type" => "DELETE"
    }
  end

end
