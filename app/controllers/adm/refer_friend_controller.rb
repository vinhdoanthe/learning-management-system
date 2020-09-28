class Adm::ReferFriendController < Adm::AdmController

  include SocialCommunity::ReferFriendHelper

  def index
    rf_service = SocialCommunity::ReferFriendsService.new
    @refer_friends = rf_service.get_list index_params 
    @state_report = rf_service.get_state_report
  end


  private

  def index_params
    params.permit(:page, :state, :rf_date_start, :rf_date_end)
  end
end
