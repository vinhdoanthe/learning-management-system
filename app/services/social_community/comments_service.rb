class SocialCommunity::CommentsService
  def self.comment_decorator comment
    return nil if comment.nil?
    user_fullname = ''
    user = User::Account::User.where(id: comment.commented_by).first
    if user.nil? 
      user_fullname = ''
    elsif user.is_teacher?
      user_fullname = user.faculty_name
    elsif user.is_student?
      user_fullname = user.student_name
    end
    {
      :user_fullname => user_fullname,
      :content => comment.content
    }
  end
end
