module PostConstants
  module PostType
    SC_QA_THREAD = 'SocialCommunity::QuestionAnswer::Thread'
    SC_PT_POST = 'SocialCommunity::Feed::PhotoPost'
    SC_RW_POST = 'SocialCommunity::Feed::RewardPost'
    SC_ST_PROJECT_POST = 'SocialCommunity::Feed::StudentProjectPost'
    SC_REDEEM_POST = 'SocialCommunity::Feed::RedeemPost'
  end

  module PostAction

  end

  module NewfeedPostTypes
    ACCEPTED_NEWFEED_POST_TYPES = [PostType::SC_PT_POST, PostType::SC_RW_POST, PostType::SC_ST_PROJECT_POST, PostType::SC_REDEEM_POST]
    #ACCEPTED_NEWFEED_POST_TYPES = [PostType::SC_PT_POST]
  end
end
