class SocialCommunity::QuestionAnswer::MessageDecorator < SimpleDelegator
  def display_author_name
    created_user = User::Account::User.where(id: created_by).first
    return '' if created_user.nil?
    "<label for="">#{created_user.full_name}<br/><span>#{created_user.role}</span></label>"
  end
end
