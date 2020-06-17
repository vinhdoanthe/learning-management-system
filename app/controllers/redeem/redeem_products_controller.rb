class Redeem::RedeemProductsController < ApplicationController
  def index
    @redeem_products = Redeem::RedeemProduct.all
  end

  def show
    @redeem_product = Redeem::RedeemProduct.where(id: params[:id]).first
  end
end
