class User::Reward::CoinStarsService
  def self.get_transactions params, user
    User::Reward::CoinStarTransaction.where(give_to: user.id)
      .order(:created_at => :DESC)
      .page(params[:page])
  end

  def redeem_coin_transaction coinstarable, student_user_id, amount
    create_coin_star_transaction coinstarable, student_user_id, 0, amount, 'coin'
  end

  def reward_coin_star coinstarable, student_user_id, give_by
    validate_transaction coinstarable
    setting = coinstarable.coin_star_setting

    ActiveRecord::Base.transaction do
      if setting.is_add_star
        amount = setting.star
        create_coin_star_transaction coinstarable, student_user_id, give_by, amount, 'star'
        update_coin_star_user student_user_id, amount, 'star'
      end

      if setting.is_add_coin
        amount = setting.coin
        create_coin_star_transaction coinstarable, student_user_id, give_by, amount, 'star'
        update_coin_star_user student_user_id, amount, 'coin'
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


  def update_coin_star_user user_id, amount, type
    user = User::Account::User.where(id: user_id).first
    
    if type == RewardConstants::Type::TEKY_COIN
      user.coin = user.coin.to_i + amount
    elsif type == RewardConstants::Type::TEKY_STAR
      user.star = user.star.to_i + amount
    end

    user.save!
  end
  
  def validate_transaction coinstarable
    if User::Reward::CoinStarTransaction.where(coinstarable_id: coinstarable.id).first.present?
      return { type: 'danger', message: 'Đã khen thưởng!' }
    end
  end
end
