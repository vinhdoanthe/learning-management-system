class SocialCommunity::QuestionAnswer::MessageDecorator < SimpleDelegator
  def initialize(message)
    @message = SocialCommunity::QuestionAnswer::Message.where(id: message._id).first
    @created_user = User::Account::User.where(id: @message.created_by).first
    __setobj__(@message)
  end

  def display_author_name
    return '' if @created_user.nil?
    "<label for="">#{@created_user.full_name}<br/><span>#{@created_user.role}</span></label>"
  end

  def display_author_avatar
    User::Account::UserDecorator.new(@created_user).display_avatar
  end
  
  def display_created_time
    return '' if @message.nil?
    "<span>#{@message.created_at.strftime('%d/%m/%Y %I:%M%p')}</span>"
  end
end
