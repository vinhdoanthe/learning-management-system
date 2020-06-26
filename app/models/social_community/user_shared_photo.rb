class SocialCommunity::UserSharedPhoto < ApplicationRecord
  self.table_name = 'user_shared_photos'
  mount_uploader :image, SocialCommunity::UserSharedPhotoUploader

  belongs_to :user_custom_post_content, class_name: 'SocialCommunity::UserCustomPostContent', foreign_key: 'user_custom_post_content_id'
  has_one :post_activity, class_name: 'SocialCommunity::Feed::PostActivity' 
  
  def to_jq_upload
    {
      "name" => read_attribute(:avatar),
      "size" => avatar.size,
      "url" => avatar.url,
      "thumbnail_url" => avatar.thumb.url,
      "delete_url" => picture_path(:id => id),
      "delete_type" => "DELETE"
    }
  end
end
