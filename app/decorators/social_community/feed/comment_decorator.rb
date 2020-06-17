class SocialCommunity::Feed::CommentDecorator < SimpleDelegator
  def initialize(comment)
    @user = User::Account::User.where(id: comment[:author_id]).first
  end

  def display_comment_avatar
    User::Account::UserDecorator.new(@user).display_avatar
  end
end
