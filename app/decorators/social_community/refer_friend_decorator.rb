class SocialCommunity::ReferFriendDecorator < SimpleDelegator

  def rf_date_frm
    return '' if created_at.nil?

    created_at.strftime(I18n.t('date.formats.default'))
  end

end
