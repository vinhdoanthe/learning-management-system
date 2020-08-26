class SocialCommunity::ReferFriendsController < ApplicationController
  before_action :set_paper_trail_whodunnit
  before_action :params_permit, only: [:create_new_refer_request]

  def index
    @refers = SocialCommunity::ReferFriend.where(refer_by: current_user)
  end

  def create_new_refer_request
    result = SocialCommunity::ReferFriendsService.new.create_refer_friend(@params[:email], @params[:mobile], @params[:parent_name], @params[:note], current_user.id)
    key = result[:refer_friend]
    response = if result[:success]
                 { type: 'success', message: 'Gửi lời mời thành công'}
               else
                 { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau!' }
               end

    respond_to do |format|
      format.html
      format.js { render 'social_community/refer_friends/response', locals: { result: response, key: key, type: 'new' }}
    end
  end
  
  def cancel
    service = SocialCommunity::ReferFriendsService.new
    refer_request = SocialCommunity::ReferFriend.where(refer_key: params[:refer_key]).first
    key = ''

    if refer_request.blank?
      result = { type: 'danger', message: 'Yêu cầu giới thiệu không tồn tai' }
    else
      permission = service.can_cancel? refer_request, current_user, params[:note]

      if permission[0]
        result = service.cancel_refer_request refer_request, params[:note]
      else
        result = permisson[1]
      end
    end

    if result[:type] == 'success'
      key = params[:refer_key]
      refer_request.create_notifications if current_user.is_admin?
    end

    respond_to do |format|
      format.html
      format.js { render 'social_community/refer_friends/response', locals: { result: result, key: key, type: 'cancel' }}
    end
  end

  def confirm
    result = SocialCommunity::ReferFriendsService.new.confirm_refer_friend(params[:refer_key])
    key = result[:refer_friend]
    response = if result[:success]
                 { type: 'success', message: 'Cập nhật thành công'}
               else
                 { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau!' }
               end


    respond_to do |format|
      format.html
      format.js { render 'social_community/refer_friends/response', locals: { result: response, key: key, type: 'confirm' }}
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
