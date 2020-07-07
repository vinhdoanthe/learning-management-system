class User::Reward::CoinStarTransactionDecorator < SimpleDelegator
  def display_content
    if __getobj__.nil?
      ''
    else
      if transaction_type == RewardConstants::Type::TEKY_STAR 
        "#{I18n.t('reward.you_were_reward')} #{amount} #{I18n.t('reward.star')} #{I18n.t('reward.at')} #{created_at.strftime('%I:%M:%S %p %d/%m/%Y')}"
      elsif transaction_type == RewardConstants::Type::TEKY_COIN
      "#{I18n.t('reward.you_were_reward')} #{amount} #{I18n.t('reward.coin')} #{I18n.t('reward.at')} #{created_at.strftime('%I:%M:%S %p %d/%m/%Y')}"
      end
    end
  end
end
