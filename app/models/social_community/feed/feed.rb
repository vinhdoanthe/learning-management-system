class SocialCommunity::Feed::Feed
  attr_accessor :post, :created_user, :count_like, :count_love, :count_sad, :comments
  def initialize(post)
    @post = post
    @created_user = nil
    @count_like = 0
    @count_love = 0
    @count_sad = 0
    @comments = []
  end 
end
