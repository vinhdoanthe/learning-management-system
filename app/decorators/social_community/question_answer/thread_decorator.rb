class SocialCommunity::QuestionAnswer::ThreadDecorator < SimpleDelegator

  def display_thread_title
    created_user = User::Account::User.where(id: created_by).first
    return '' if created_user.nil?
    display_html = "<label>#{created_user.full_name}</label>"
    display_html += " " + I18n.t('notification.qa_thread.create') + " " + I18n.t('notification.in_batch')
    batch = Learning::Batch::OpBatch.where(id: batch_id).first
    batch_code = (batch.nil? ? '' : batch.code)
    display_html += " " + batch_code
    display_html.html_safe
  end

  def display_thread_created_at
    created_at.strftime(I18n.t('date.formats.default'))
  end

  def display_count_replies
    count_replies = SocialCommunity::QuestionAnswer::Message.where(qa_thread_id: _id).count
    display_html = ''
    display_html += ("#{count_replies} " + "reply".pluralize(count_replies)).html_safe
  end
end
