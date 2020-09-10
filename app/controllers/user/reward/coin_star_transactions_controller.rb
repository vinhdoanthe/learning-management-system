class User::Reward::CoinStarTransactionsController < ApplicationController
  def my_coin_star_transactions
    if current_user.nil?
      @coin_star_transactions = []
    else
      @coin_star_transactions = User::Reward::CoinStarsService.get_transactions(params, current_user)  
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
end
