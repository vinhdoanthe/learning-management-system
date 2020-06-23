class SocialCommunity::Feed::PostsService
  attr_accessor :post 

  def initialize(post)
    @post = post
  end

  # get recented posts per request
  def self.fetch_posts user_id, time_offset_epoch = Time.now
    posts = []
    next_offset_epoch = time_offset_epoch

    user = User::Account::User.where(id: user_id).first
    
    unless user.nil?
      posts = user.sc_posts.where('sc_posts.created_at < ?', time_offset_epoch).order(created_at: :DESC).limit(1)
      if posts.blank?
        next_offset_epoch = 0
      else 
        next_offset_epoch = posts.last.created_at
      end
    end
    [posts, next_offset_epoch]
  end

  def self.decor_post_to_feed posts
    feeds = []
    posts.each do |post|
      feed = SocialCommunity::Feed::Feed.new(post)
      created_user = User::Account::User.where(id: post.posted_by).first
      feed.created_user = created_user
      posts_service = SocialCommunity::Feed::PostsService.new(post)
      count_like, count_love, count_sad = posts_service.count_reactions
      comments = posts_service.get_comments
      decored_comments = []
      comments.each do |comment|
        decored_comments << SocialCommunity::CommentsService.comment_decorator(comment)
      end
      feed.count_like = count_like
      feed.count_love = count_love
      feed.count_sad = count_sad
      feed.comments = decored_comments
      feeds << feed
    end
    
    feeds
  end
  
  # params
  # user
  # post_offset
  # last_post_date_time
  #
  def self.new_feeds params
    # permit params
    post_offset = params[:post_offset]
    last_post_date_time = params[:last_post_date_time]
    if post_offset.nil? or post_offset == 0
      post_offset = SocialCommunity::Feed::Post.where(type: PostConstants::NewfeedPostTypes::ACCEPTED_NEWFEED_POST_TYPES).last.id
    end
    if last_post_date_time.nil?
      last_post_date_time = Time.now
    end
    @posts = SocialCommunity::Feed::Post.where('updated_at <= ? and id <= ? and type in (?)', last_post_date_time, post_offset, PostConstants::NewfeedPostTypes::ACCEPTED_NEWFEED_POST_TYPES)
      .order(updated_at: :DESC)
      .limit(2)
    @feeds = decor_post_to_feed @posts
  end
  
  def self.fetch_feeds user_id, time_offset_epoch
    posts, next_time_offset = fetch_posts user_id, time_offset_epoch
    feeds = decor_post_to_feed posts
    [feeds, next_time_offset]
  end

  def count_reactions
    if @post.nil?
      return [nil, nil, nil]
    else
      count_like = @post.reactions.where(react_type: SocialCommunity::Constant::ReactionType::LIKE).count 
      count_love = @post.reactions.where(react_type: SocialCommunity::Constant::ReactionType::LOVE).count
      count_sad = @post.reactions.where(react_type: SocialCommunity::Constant::ReactionType::SAD).count
      return [count_like, count_love, count_sad]
    end
  end

  def self.count_like post
    if post.nil?
      nil
    else
      post.reactions.where(react_type: SocialCommunity::Constant::ReactionType::LIKE).count 
    end
  end

  def self.count_love post
    if post.nil?
      nil
    else
      post.reactions.where(react_type: SocialCommunity::Constant::ReactionType::LOVE).count 
    end
  end

  def self.count_sad post
    if post.nil?
      nil
    else
      post.reactions.where(react_type: SocialCommunity::Constant::ReactionType::SAD).count 
    end
  end

  def get_comments
    @post.comments.order(created_at: :DESC).to_a
  end
end
