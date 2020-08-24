module NotificationConstants
  module Type
    SC_QA_THREAD = 'SocialCommunity::QuestionAnswer::Thread'
    SC_PT_POST = 'SocialCommunity::Feed::PhotoPost'
    SC_RW_POST = 'SocialCommunity::Feed::RewardPost'
    SC_ST_PROJECT_POST = 'SocialCommunity::Feed::StudentProjectPost'
    SC_REDEEM_POST = 'SocialCommunity::Feed::RedeemPost'
    SC_REFER_FRIEND = 'SocialCommunity::ReferFriend'
    SC_REFER_FRIEND_POST = 'SocialCommunity::Feed::ReferFriendPost'
    STUDENT_FEEDBACK = 'Learning::Batch::SessionStudentFeedback'
  end
  module Key
    SC_QA_THREAD_CREATE = 'qa_thread.create'
    SC_QA_THREAD_REPLY = 'qa_thread.reply'
    SC_PT_POST_CREATE = 'post.create'
    SC_PT_POST_COMMENT = 'post.comment'
    SC_RW_POST_CREATE = 'post.create'
    SC_RW_POST_COMMENT = 'post.comment'
    SC_ST_PROJECT_POST_CREATE = 'post.create'
    SC_ST_PROJECT_POST_COMMENT = 'post.comment'
    SC_REDEEM_POST_CREATE = 'post.create'
    SC_REDEEM_TRANSACTION_CANCEL = 'CANCEL_TRANSACTION'
    SC_REDEEM_TRANSACTION_APPROVE = 'APPROVE_TRANSACTION'
    SC_REDEEM_TRANSACTION_COMPLETE = 'COMPLETE_TRANSACTION'
    STUDENT_FEEDBACK_CREATE = 'feedback.create'
  end
end
