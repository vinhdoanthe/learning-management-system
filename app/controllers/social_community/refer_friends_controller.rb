class SocialCommunity::ReferFriendsController < ApplicationController
  before_action :set_paper_trail_whodunnit
  before_action :params_permit, only: [:create_new_refer_request]

  def index
    @refers = SocialCommunity::ReferFriend.where(refer_by: current_user)
  end

  def create_new_refer_request
    result = SocialCommunity::ReferFriendsService.new.create_refer_friend(@params[:email], @params[:mobile], @params[:parent_name], @params[:note], current_user.id)

    respond_to do |format|
      format.html
      format.js { render 'social_community/refer_friends/respond', locals: { result: result.to_json }}
    end
  end
  
  def cancel
  end

  def confirm
    
    result = SocialCommunity::ReferFriendsService.new.confirm_refer_friend(params[:refer_key])
    
    if result[:success]
      render :partial => 'confirm_success', :locals => {result: result}
    else
      render :partial => 'confirm_failed', :locals => {result: result}
    end
  end

  def approve
  end

  def discard
    result = SocialCommunity::ReferFriendsService.new.discard_refer_friend(params[:refer_key])

    if result[:success]
      render :partial => 'discard_success', :locals => {result: result}
    else
      render :partial => 'discard_failed', :locals => {result: result}
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
end
