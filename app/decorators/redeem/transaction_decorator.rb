class Redeem::TransactionDecorator < SimpleDelegator

  include ActionView::Helpers::NumberHelper

  def order_date_frm
    return '' if created_at.nil?

    created_at.strftime(I18n.t('date.formats.default'))
  end

  def total_paid_frm
    return '' if total_paid.nil?

    number_with_precision(total_paid, :delimiter => '.', :precision => 0)
  end    

  def amount_frm
    return '' if amount.nil?

    number_with_precision(amount, :delimiter => '.', :precision => 0)
  end

  def status_label
    if status_new?
      I18n.t('adm.redeem.transaction_new_lbl')
    elsif status_ready?
      I18n.t('adm.redeem.transaction_ready_lbl')
    elsif status_cancel?
      I18n.t('adm.redeem.transaction_cancel_lbl')
    elsif status_done?
      I18n.t('adm.redeem.transaction_done_lbl')
    end
  end

end
