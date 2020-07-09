class Redeem::RedeemProductsController < ApplicationController
  
  def index
    
    @page_title 	 = t('adm.redeem.redeem_points')
    @redeem_products = Redeem::RedeemProduct.select('id,name,brand, available_color,available_size,description,price,category ').all

  end

  def show
  	@page_title 	 = t('sidebar.redeem')
    @redeem_product  = Redeem::RedeemProduct.where(id: params[:id]).first
  end
end
