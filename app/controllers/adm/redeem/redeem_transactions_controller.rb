class Adm::Redeem::RedeemTransactionsController < Adm::AdmController
  before_action :set_transaction, only: [:show, :cancel, :approve, :complete]

  def index
    @transactions = Redeem::RedeemTransactionService.new.list_transactions index_params
    @status_report = Redeem::RedeemTransactionService.new.get_status_report params
  end

  def show
    respond_to do |format|
      format.html
      format.js {
        render 'show', :locals => {transaction: @transaction, mode: params[:mode]}
      }
    end
  end

  def cancel
    redeem_transaction_service = Redeem::RedeemTransactionService.new
    result = redeem_transaction_service.cancel_transaction(@transaction, params[:note], current_user)
    respond_to do |format|
      format.json {
        render json: result
      }
    end
  end

  def approve
    redeem_transaction_service = Redeem::RedeemTransactionService.new
    result = redeem_transaction_service.approve_transaction(@transaction, params[:note], current_user)
    respond_to do |format|
      format.json {
        render json: result
      }
    end
  end

  def complete
    redeem_transaction_service = Redeem::RedeemTransactionService.new
    result = redeem_transaction_service.complete_transaction(@transaction, params[:note], current_user)
    respond_to do |format|
      format.json {
        render json: result
      }
    end
  end

  private
  def set_transaction
    @transaction = Redeem::RedeemTransaction.where(id: params[:id]).first
  end

  def index_params
    params.permit(:page, :status, :order_date_start, :order_date_end)
  end
end
