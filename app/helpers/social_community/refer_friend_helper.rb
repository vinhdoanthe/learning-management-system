module SocialCommunity::ReferFriendHelper

  def state_css_class(rf_state)
    if rf_state == ReferFriendConstants::REFER_FRIEND_STATE_WAITING
      css_class = 'warning' 
    elsif rf_state == ReferFriendConstants::REFER_FRIEND_STATE_CONFIRM
      css_class = 'primary'
    elsif rf_state == ReferFriendConstants::REFER_FRIEND_STATE_FAILED
      css_class = 'danger'
    elsif rf_state == ReferFriendConstants::REFER_FRIEND_STATE_SUCCEED
      css_class = 'success'
    end

    css_class
  end

  def state_display_lbl(rf_state)
    if rf_state == ReferFriendConstants::REFER_FRIEND_STATE_WAITING
      display_lbl = I18n.t('adm.refer_friend.state_waiting_lbl') 
    elsif rf_state == ReferFriendConstants::REFER_FRIEND_STATE_CONFIRM
      display_lbl = I18n.t('adm.refer_friend.state_confirm_lbl') 
    elsif rf_state == ReferFriendConstants::REFER_FRIEND_STATE_FAILED
      display_lbl = I18n.t('adm.refer_friend.state_failed_lbl') 
    elsif rf_state == ReferFriendConstants::REFER_FRIEND_STATE_SUCCEED
      display_lbl = I18n.t('adm.refer_friend.state_succeed_lbl') 
    end

    display_lbl
  end

end
