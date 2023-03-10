class Redeem::RedeemTransactionsController < ApplicationController
  before_action :find_transaction, :check_checksum, only: [:update_transaction]
  before_action :validate_params, only: [:create_transaction]
  skip_before_action :verify_authenticity_token

  def company_products
    transactions = Redeem::RedeemTransaction.where(company_id: params[:company_id])
    products = Redeem::RedeemProduct.where(id: transactions.pluck(:redeem_product_id))

    respond_to do |format|
      format.html
      format.js { render 'redeem/redeem_products/js/admin_product', locals: { transaction: transaction, products: products } }
    end
  end

  def admin_product
  end

  def update_transaction
     result = Redeem::RedeemTransactionService.new.update_transaction @transaction.id, params[:status]

     if result
       render json: { sucess: true }
     else
       render json: { sucess: false }
     end
  end

  def create_transaction
    result = Redeem::RedeemTransactionService.new.create_transaction params, current_user

    render json: result
  end

  def redeem_history
    @redeems, @images = Redeem::RedeemTransactionService.new.redeem_history params[:user_id]

    respond_to do |format|
      format.html
      format.js { render 'redeem/redeem_history' }
    end
  end

  private

  def find_transaction
    @transaction = Redeem::RedeemTransaction.where(id: params[:transaction_id]).first
  end

  def validate_params
    attributes = ['product_color', 'product_size', 'product_amount']
    result = true
    attributes.each{ |att| result = false if params[att].blank? }
    
    unless result
      render json: { type: 'danger', message: 'Thiếu thông tin! Vui lòng kiểm tra lại!' }
      return
    end
  end

  def check_checksum
    unless params[:checksum] == ''
      render json: {success: false, message: "Sai thong tin"}
      return
    end
  end
end
