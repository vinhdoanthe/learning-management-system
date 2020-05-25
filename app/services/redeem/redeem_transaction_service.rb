class Redeem::RedeemTransactionService
  def create_transaction params, user
    ActiveRecord::Base.transaction do
      transaction = Redeem::RedeemTransaction.new
      transaction.student_id = user.id
      product = Redeem::RedeemProduct.where(id: params[:product_id]).first
      return false if product.blank?

      transaction.redeem_product_id = product.id
      transaction.color = params[:product_color]
      transaction.size = params[:product_size]
      transaction.status = 'new'
      transaction.company_id = params[:product_company]
      transaction.expected_time = params[:product_time]
      transaction.amount = params[:product_amount]
      transaction.total_paid = params[:product_amount].to_i * product.price

      if transaction.save!
        type = 1
        update_star transaction, type
        true
      end
    end

  end

  def update_transaction transaction, status
    if status == 'ready'
      type = 1
    elsif status == 'cancel'
      type = -1
    end

    update_star transaction, type
    coin_star_setting = Struct.new(:redeem)
    setting = coin_star_setting.new(- transaction.amount * type)
    User::Reward::CoinStarsService.new.create_coin_star_transaction setting, transaction.student_id, 'redeem', transaction.student_id 
    transaction.update!(status: status)
  end

  def update_star transaction, type

  end
end
