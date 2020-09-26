module Redeem::RedeemTransactionHelper

  def status_css_class transaction
    if transaction.status_new?
      class_name = 'success'
    elsif transaction.status_ready?
      class_name = 'info'
    elsif transaction.status_cancel?
      class_name = 'danger'
    elsif transaction.status_done?
      class_name = 'secondary'
    end

    class_name
  end

end
