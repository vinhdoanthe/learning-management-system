class SocialCommunity::Feed::PostActivity < ApplicationRecord
    belongs_to :sc_post, class_name: 'SocialCommunity::Feed::Post'
    belongs_to :activitiable, polymorphic: true
end
