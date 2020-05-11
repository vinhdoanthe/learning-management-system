class Redeem::RedeemTransactionsController < ApplicationController
  before_action :find_transaction, only: [:update_transaction]
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
    result = false
    if current_user.is_admin?
      result = Redeem::RedeemTransactionService.new.update_transaction @transaction.id, params[:status]
    end

    if result

    end
  end

  def create_transaction
    result = Redeem::RedeemTransactionService.new.create_transaction params, current_user
    if result
      render json: { type: 'success', message: 'Đổi quà thành công!' }
    else
      render json: { type: 'danger', message: 'Có lỗi xảy ra! Vui lòng thử lại sau!' }
    end
  end

  private

  def find_transaction
    @transaction = Redeem::RedeemTransaction.where(id: params[:transaction_id]).first
  end
end
