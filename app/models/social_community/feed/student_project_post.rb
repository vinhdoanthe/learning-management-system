class SocialCommunity::Feed::StudentProjectPost < SocialCommunity::Feed::Post
  has_one :sc_student_project, class_name: 'SocialCommunity::ScStudentProject', foreign_key: 'sc_post_id'
end
