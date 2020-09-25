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
end
