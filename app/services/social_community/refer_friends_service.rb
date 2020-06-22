class SocialCommunity::ReferFriendsService
  def create_refer_request params
    #create new record
    begin
    request = SocialCommunity::ReferFriend.create(params)
    refer_code = generate_refer_code params[:refer_by]
    state = 'waiting'
    request.update(code: refer_code, state: state)

    request_refer_odoo request
    request.create_notifications

    { type: 'success', message: 'Cảm ơn chờ xử lý' }
    rescue StandardError => e
      { type: 'danger', message: 'Đã có lỗi xảy ra. Vui lòng thử lại sau!' }
    end
  end

  def update_refer_request params
    refer = SocialCommunity::ReferFriend.where(id: params[:refer_id], code: params[:refer_code]).first
    
    if refer.update(state: params[:state])
      if params[:state] == 'approve'
        post = create_refer_post refer
        SocialCommunity::Feed::UserPostsService.create_multiple post.id, [refer.refer_by]
        post.create_notifications
      else
      refer.create_notifications
      end 
    end
  end

  def request_refer_odoo request

  end

  def create_refer_post refer
    post = SocialCommunity::Feed::ReferFriendPost.create(posted_by: refer.refer_by)
    refer_post = SocialCommunity::Feed::PostActivity.new
    refer_post.sc_post_id = post.id
    refer_post.activitiable = refer
    refer_post.save
    post
  end

  def generate_refer_code user_id
    "REFER-" + (0..8).map { (65 + rand(26)).chr }.join + user_id
  end

  def self.get_subscribed_users user_id
    [User::Account::User.where(id: user_id).first]
  end
end
