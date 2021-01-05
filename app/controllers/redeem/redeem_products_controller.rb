class Redeem::RedeemProductsController < ApplicationController
  
  def index
    @page_title 	 = t('adm.redeem.redeem_points')
    @redeem_products = Redeem::RedeemProduct.order(price: :ASC).page(params[:page]).per(20)
  end

  def product_detail
    redeem_product = Redeem::RedeemProduct.where(id: params[:product_id]).first
    size = Redeem::RedeemProductSize.where(id: params[:size]).first
    color = Redeem::RedeemProductColor.where(id: params[:color]).first

    if redeem_product.present?
      brand_name = redeem_product.redeem_product_brand.name
    end

    respond_to do |format|
      format.html
      format.js { render "redeem/redeem_products/js/product_detail", locals: { product: redeem_product, brand_name: brand_name, size: size, color: color } }
    end
  end
end
