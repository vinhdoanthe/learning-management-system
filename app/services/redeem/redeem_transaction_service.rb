class Redeem::RedeemTransactionService
  def create_transaction params, user
    result = { type: "danger", message: "Đã có lỗi xảy ra! Vui lòng thử lại" }
    post = ''
    ActiveRecord::Base.transaction do
      transaction = Redeem::RedeemTransaction.new
      transaction.student_id = user.id
      product = Redeem::RedeemProduct.where(id: params[:product_id]).first
      return { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại' } if product.blank?

      transaction.redeem_product_id = product.id
      transaction.color = params[:product_color]
      transaction.size = params[:product_size]
      transaction.status = 'new'
      transaction.company_id = params[:product_company]
      transaction.expected_time = params[:product_time]
      transaction.amount = params[:product_amount]
      transaction.total_paid = params[:product_amount].to_i * product.price
      return { type: 'danger', message: 'Không đủ Teky đồng để đổi sản phẩm' } if transaction.total_paid > user.coin

      if transaction.save!
      post = create_redeem_post transaction, user
        type = -1
        update_coin transaction, type
        result = { type: 'success', message: 'Yêu cầu đồi quà thành công!' }
      end
    end
    
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
      update_star transaction, type
    end

    if transaction.update!(status: status)
      post = create_redeem_post transaction, user

      if status == 'done'
        SocialCommunity::Feed::UserPostsService.create_multiple post.id, [user.id]
      end
    end
    true
  end

  private

  def update_coin transaction, type
    create_coins_transaction transaction, type
  end

  def create_coins_transaction transaction, type
    coin_star_setting = Struct.new(:redeem)
    setting = coin_star_setting.new(transaction.amount)
    User::Reward::CoinStarsService.new.create_coin_star_transaction setting, transaction.student_id, 'redeem', type
  end
end
