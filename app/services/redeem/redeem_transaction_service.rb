class Redeem::RedeemTransactionService
  def create_transaction params, user
    size = Redeem::RedeemProductSize.where(id: params[:product_size]).first
    color = Redeem::RedeemProductColor.where(id: params[:product_color]).first
    result = { type: "danger", message: "Đã có lỗi xảy ra! Vui lòng thử lại" }
    return result if size.blank? || color.blank?

    post = ''
    transaction = Redeem::RedeemTransaction.new
    transaction.student_id = user.id
    product = Redeem::RedeemProduct.where(id: params[:product_id]).first
    return { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại' } if product.blank?

    product_items = check_product_item product, size, color, params[:product_amount].to_i

    if product_items.blank?
      return { type: 'danger', message: 'Sản phẩm đã hết hàng! Vui lòng quay lại sau' }
    end

    transaction.product_id = product.id
    transaction.color_id = color.id
    transaction.size_id = size.id
    transaction.status = RedeemConstants::TransactionState::REDEEM_TRANSACTION_STATE_NEW
    transaction.amount = params[:product_amount]
    transaction.total_paid = params[:product_amount].to_i * product.price
    return { type: 'danger', message: 'Không đủ Teky đồng để đổi sản phẩm' } if transaction.total_paid > user.coin

    ActiveRecord::Base.transaction do
      transaction.save!
      post = create_redeem_post transaction, user
      type = -1
      update_coin transaction, type
      result = { type: 'success', message: 'Yêu cầu đồi quà thành công!' }
    rescue => e
      puts e
      return { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau!' }
    end
    
    product_items.update_all ({ transaction_id: transaction.id, state: RedeemConstants::ProductItem::STATE_LOCKED })
    post.create_notifications
    result

  end

  def create_redeem_post transaction, user
    post = SocialCommunity::Feed::RedeemPost.create(posted_by: user.id)
    post_redeem = SocialCommunity::Feed::PostActivity.new
    post_redeem.sc_post_id = post.id
    post_redeem.activitiable = transaction
    post_redeem.save
    post
  end

  def update_transaction transaction, status
    if status == 'cancel'
      type = 1
      update_coin transaction, type
    end

    if transaction.update!(status: status)
      post = create_redeem_post transaction, user

      if status == 'done'
        SocialCommunity::Feed::UserPostsService.create_multiple post.id, [user.id]
      end
    end
    true
  end

  def check_product_item product, size, color, amount
    return nil if size.blank? || color.blank?

    product_items = product.redeem_product_items.where(size_id: size.id, color_id: color.id, state: RedeemConstants::ProductItem::STATE_AVAILABLE)

    if product_items.count >= amount
      product_items.limit(amount)
    else
      return nil
    end
  end

  private

  def update_coin transaction, type
    create_coins_transaction transaction, type
  end

  def create_coins_transaction transaction, type
    amount = transaction.total_paid * type
    User::Reward::CoinStarsService.new.redeem_coin_transaction transaction, transaction.student_id, amount
  end
end
