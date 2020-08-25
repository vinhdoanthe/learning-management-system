include RewardConstants::Type
include RewardConstants::DefaultUsers
include RewardConstants::Factor

class User::Reward::CoinStarsService
  def self.get_transactions params, user
    User::Reward::CoinStarTransaction.where(give_to: user.id)
      .order(:created_at => :DESC)
      .page(params[:page])
  end

  def redeem_coin_transaction coinstarable, student_user_id, amount
    ActiveRecord::Base.transaction do
      create_coin_star_transaction coinstarable, student_user_id, 0, amount, TEKY_COIN
      update_coin_star_user student_user_id, amount, TEKY_COIN
    end
  end

  def reward_coin_star coinstarable, student_user_id, give_by
    return if validate_transaction coinstarable
    setting = coinstarable.coin_star_setting

    ActiveRecord::Base.transaction do
      if setting.is_add_star
        amount = setting.star
        create_coin_star_transaction coinstarable, student_user_id, give_by, amount, TEKY_STAR
        update_coin_star_user student_user_id, amount, TEKY_STAR
      end

      if setting.is_add_coin
        amount = setting.coin
        create_coin_star_transaction coinstarable, student_user_id, give_by, amount, TEKY_COIN
        update_coin_star_user student_user_id, amount, TEKY_COIN
      end
    end

  end

  def create_coin_star_transaction coinstarable, student_user_id, give_by, amount, type
    transaction = User::Reward::CoinStarTransaction.new
    transaction.give_to = student_user_id
    transaction.give_by = give_by
    transaction.amount = amount
    transaction.transaction_type = type
    transaction.coinstarable = coinstarable
    transaction.save
  end


  def cashback_cancel_redeem_transaction transaction, admin_user
    # TODO: need to update to user real admin_user

    create_coin_star_transaction transaction, transaction.student_id, SYSTEM_USER, transaction.total_paid, TEKY_COIN 

    update_coin_star_user transaction.student_id, transaction.total_paid, TEKY_COIN
  end

  def update_coin_star_user user_id, amount, type
    user = User::Account::User.where(id: user_id).first
    
    if type == TEKY_COIN
      user.coin = user.coin.to_i + amount
    elsif type == TEKY_STAR
      user.star = user.star.to_i + amount
    end

    user.save!
  end
  
  def validate_transaction coinstarable
    User::Reward::CoinStarTransaction.where(coinstarable_id: coinstarable.id, coinstarable_type: coinstarable.class.to_s).first.present?
  end

  def create_refund_transaction class_name, student, teacher
    coinstarable = class_name.constantize.new
    setting = coinstarable.coin_star_setting

    ActiveRecord::Base.transaction do
      if setting.is_add_star
        amount = - setting.star
        create_coin_star_transaction coinstarable, student, teacher, amount, TEKY_STAR
        update_coin_star_user student, amount, TEKY_STAR
      end

      if setting.is_add_coin
        amount = - setting.coin
        create_coin_star_transaction coinstarable, student, teacher, amount, TEKY_COIN
        update_coin_star_user student, amount, TEKY_COIN
      end
    end
  end
end
