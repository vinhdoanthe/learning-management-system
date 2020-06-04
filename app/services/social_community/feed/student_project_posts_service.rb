class SocialCommunity::Feed::StudentProjectPostsService < SocialCommunity::Feed::PostsService

  def self.get_subscribed_users post_id
    post = SocialCommunity::Feed::StudentProjectPost.where(id: post_id).first
    return [] if post.blank?

    student_ids = Learning::Batch::OpStudentCourse.where(batch_id: post.batch_id, state: 'on').pluck(:student_id)
    User::Account::User.where(student_id: student_ids).all
  end

  def self.subscribed_users batch_id
    student_ids = Learning::Batch::OpStudentCourse.where(batch_id: batch_id, state: 'on').pluck(:student_id)
    User::Account::User.where(student_id: student_ids).pluck(:id)
  end
end
