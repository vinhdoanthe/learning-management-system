class SocialCommunity::ReferFriendsController < ApplicationController
  before_action :params_permit, only: [:create_new_refer_request]

  def index
    @refers = SocialCommunity::ReferFriend.where(refer_by: current_user)
  end

  def create_new_refer_request
    binding.pry
    result = SocialCommunity::ReferFriendsService.new.create_refer_request @params

    respond_to do |format|
      format.html
      format.js { render 'social_community/refer_friends/respond', locals: { result: result.to_json }}
    end
  end

  def update_refer_request
    SocialCommunity::ReferFirendsService.new.update_refer_request params[:refer_id], params[:state]
  end

  private

  def params_permit
    @params = params[:social_community_refer_friend].permit!
  end
end
