class SocialCommunity::ReferFriendsController < ApplicationController
  before_action :set_paper_trail_whodunnit
  before_action :params_permit, only: [:create_new_refer_request]
  skip_before_action :authenticate_user!, only: [:confirm, :discard]

  def index
    @refers = SocialCommunity::ReferFriend.where(refer_by: current_user).order(created_at: :DESC)
  end

  def create_new_refer_request
    result = SocialCommunity::ReferFriendsService.new.create_refer_friend(@params[:email], @params[:mobile], @params[:parent_name], @params[:note], current_user.id)

    respond_to do |format|
      format.html
      format.js { render 'social_community/refer_friends/response', locals: { result: result, type: 'new' }}
    end
  end
  
  def cancel
    permission = authorize_cancel_refer params[:refer_key]

    if permission[:success]
      result = SocialCommunity::ReferFriendsService.new.cancel_refer_request permission[:key], params[:note]
    else
      result = permission
    end

    respond_to do |format|
      format.html
      format.js { render 'social_community/refer_friends/response', locals: { result: result, type: 'cancel' }}
    end
  end

  def confirm
    result = SocialCommunity::ReferFriendsService.new.confirm_refer_friend(params[:refer_key])

    if result[:success]
      render template: 'social_community/refer_friends/partials/confirms/confirm_success', :locals => {result: result}, layout: false
    else
      render template: 'social_community/refer_friends/partials/confirms/confirm_failed', :locals => {result: result}, layout: false
    end
  end

  def approve
  end

  def discard
    result = SocialCommunity::ReferFriendsService.new.discard_refer_friend(params[:refer_key])

    if result[:success]
      render template: 'social_community/refer_friends/partials/discards/discard_success', :locals => {result: result}, layout: false
    else
      render template: 'social_community/refer_friends/partials/discards/discard_failed', :locals => {result: result}, layout: false
    end
  end

  def update_refer_request
    SocialCommunity::ReferFirendsService.new.update_refer_request params[:refer_id], params[:state]
  end

  private

  def params_permit
    @params = params[:social_community_refer_friend].permit!
  end

  def confirm_refer_key_params
    params.permit(:refer_key)
  end

  def discard_refer_key_params
    params.permit(:refer_key)
  end

  def authorize_cancel_refer refer_key
    SocialCommunity::ReferFriendsService.new.can_cancel? refer_key, current_user, params[:note]
  end
end
