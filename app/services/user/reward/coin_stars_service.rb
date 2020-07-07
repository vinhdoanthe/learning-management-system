class User::Reward::CoinStarsService
  
  def self.get_transactions params, user
    User::Reward::CoinStarTransaction.where(give_to: user.id)
      .order(:created_at => :DESC)
      .page(params[:page])
  end

  def reward_coin_star key, target, type, give_by
    value = User::Reward::TekyCoinStarActivitySetting.where(setting_key: key).first
    return if value.blank?
      
    create_coin_star_transaction value, target, type, give_by, 1
  end

  def create_coin_star_transaction setting, user_id, type, give_by, update_type
    # User::Reward::CoinStarTransaction.with_session do |s|
    # s.start_transaction
      transaction = User::Reward::CoinStarTransaction.new
      if update_type.present?
        transaction.amount = setting.send(type) * update_type
      else
        transaction.amount = setting.send(type)
      end

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
