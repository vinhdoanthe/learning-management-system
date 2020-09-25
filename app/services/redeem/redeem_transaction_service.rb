include RedeemConstants::TransactionState
include RedeemConstants::ProductItem
include RedeemConstants::Action

class Redeem::RedeemTransactionService

  def list_transactions params
    transactions = Redeem::RedeemTransaction.includes(:redeem_product, :user, :redeem_product_color, :redeem_product_size)
      .order(:created_at => :ASC)
      .page(params[:page])

    transactions
  end

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
    transaction.status = REDEEM_TRANSACTION_STATE_NEW
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

  def check_product_item product, size, color, amount
    return nil if size.blank? || color.blank?

    product_items = product.redeem_product_items.where(size_id: size.id, color_id: color.id, state: RedeemConstants::ProductItem::STATE_AVAILABLE)

    if product_items.count >= amount
      product_items.limit(amount)
    else
      return nil
    end
  end

  def cancel_transaction transaction, note, admin_user
    # release product items
    # update transaction state, admin_note
    # update user's coin, create cashback coin_start_transaction
    # create notification
    # send email
    result = {}

    if transaction.status_done? || transaction.status_cancel? 
      result[:success] = false
      return result
    end

    items = transaction.redeem_product_items.where(:state => STATE_LOCKED)

    c_s_transaction_service = User::Reward::CoinStarsService.new
    if c_s_transaction_service.cashback_cancel_redeem_transaction transaction, admin_user

      ActiveRecord::Base.transaction do
        items.update(:transaction_id => nil, :state => STATE_AVAILABLE)
        transaction.update(:status => REDEEM_TRANSACTION_STATE_CANCEL, :admin_note => note)

        result = {
          :success => true,
          :transaction_status => REDEEM_TRANSACTION_STATE_CANCEL,
          :transaction_id => transaction.id,
          :note => note&.html_safe,
          :show_url => Rails.application.routes.url_helpers.adm_redeem_redeem_transactions_show_path(transaction.id)
        }
      rescue Exception => exception
        result[:success] = false
        result[:message] = exception.inspect
      end

      if result[:success]
        # create notification
        redeem_post = transaction.post_activity&.sc_post
        redeem_post.notify :users, key: CANCEL_TRANSACTION

        # TODO: send email
      end

      return result
    else
      result[:success] = false
      return result
    end
  end

  def approve_transaction transaction, note, admin_user
    # update transaction: state, note
    # create notification
    # send email

    result = {}

    if !transaction.status_new?
      result[:success] = false
      return result
    end

    if transaction.update(:status => REDEEM_TRANSACTION_STATE_READY, :admin_note => note)
      redeem_post = transaction.post_activity&.sc_post
      redeem_post.notify :users, key: APPROVE_TRANSACTION

      # TODO: send email

      result = {
        :success => true,
        :transaction_type => REDEEM_TRANSACTION_STATE_READY,
        :transaction_id => transaction.id,
        :note => note&.html_safe,
        :show_url => Rails.application.routes.url_helpers.adm_redeem_redeem_transactions_show_path(transaction.id),
      } 
    else
      result[:success] = false 
    end

    return result
  end

  def complete_transaction transaction, note, admin_user
    # update transaction: state, note
    # update product items
    # create notification
    # send email

    result = {}
    
    if !transaction.status_ready?
      result[:success] = false
      return result
    end

    items = transaction.redeem_product_items.where(:state => STATE_LOCKED)

    ActiveRecord::Base.transaction do
      items.update(:state => STATE_SOLD)
      transaction.update(:status => REDEEM_TRANSACTION_STATE_DONE, :admin_note => note)

      result = {
        :success => true,
        :transaction_status => REDEEM_TRANSACTION_STATE_DONE,
        :transaction_id => transaction.id,
        :note => note&.html_safe,
        :show_url => Rails.application.routes.url_helpers.adm_redeem_redeem_transactions_show_path(transaction.id)
      }
    rescue Exception => exception
      result[:success] = false
      result[:message] = exception.inspect
    end


    if result[:success]
      # create notification
      redeem_post = transaction.post_activity&.sc_post
      redeem_post.notify :users, key: COMPLETE_TRANSACTION

      # TODO: send email
    end

    return result
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
