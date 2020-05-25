class User::Reward::CoinStarsService
  def reward_coin_star key, target, type, give_by
    value = User::Reward::TekyCoinStarActivitySetting.where(setting_key: key).first
    return if value.blank?
      
    create_coin_star_transaction value, target, type, give_by
  end

  def create_coin_star_transaction setting, user_id, type, give_by
    # User::Reward::CoinStarTransaction.with_session do |s|
    # s.start_transaction
      transaction = User::Reward::CoinStarTransaction.new
      transaction.amount = setting.send(type)
      transaction.give_to = user_id
      transaction.give_by = give_by
      transaction.transaction_type = type

      if transaction.save!
        update_coin_star_user user_id, transaction.amount, type
      end
    #  s.end_transaction
    # end
  end

  def update_coin_star_user user_id, amount, type
    user = User::Account::User.where(id: user_id).first
    
    if type == 'coin'
      user.coin = user.coin.to_i + amount
    elsif type == 'star'
      user.star = user.star.to_i + amount
    end

    user.save!
  end

end
