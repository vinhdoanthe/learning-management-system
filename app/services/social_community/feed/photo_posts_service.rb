class SocialCommunity::Feed::PhotoPostsService < SocialCommunity::Feed::PostsService
  
  def self.get_subscribed_users post_id
    # TODO find subscribed_users
    # get session_id
    post = SocialCommunity::Feed::PhotoPost.where(id: post_id).first
    photo = post.photos.first
    return [] if photo.blank?
    session_id = photo.session_id
    session = Learning::Batch::OpSession.where(id: session_id).first
    return nil if session.blank?
    student_ids = Learning::Batch::OpStudentCourse.where(batch_id: session.batch_id, state: 'on').pluck(:student_id)
    User::Account::User.where(student_id: student_ids).all
    # get student by op_student_course, op_session_student
    # get users (student, teacher)
    # return
  end

end
