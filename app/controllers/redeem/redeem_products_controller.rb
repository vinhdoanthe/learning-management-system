class Redeem::RedeemProductsController < ApplicationController
  def index
    @redeem_products = Redeem::RedeemProduct.all
  end
end
