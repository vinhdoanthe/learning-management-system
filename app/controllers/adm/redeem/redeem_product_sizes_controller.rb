class Adm::Redeem::RedeemProductSizesController < ApplicationController
  before_action :set_adm_redeem_redeem_product_size, only: [:show, :edit, :update, :destroy]

  def index
    @adm_redeem_redeem_product_sizes = Redeem::RedeemProductSize.order(:created_at => :ASC).all
  end

  def show
  end

  def new
    @adm_redeem_redeem_product_size = Redeem::RedeemProductSize.new
  end

  def edit
  end

  def create
    @adm_redeem_redeem_product_size = Redeem::RedeemProductSize.new(create_params)

    respond_to do |format|
      if @adm_redeem_redeem_product_size.save
        format.html { redirect_to adm_redeem_redeem_product_size_path(@adm_redeem_redeem_product_size), notice: 'Redeem product size was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @adm_redeem_redeem_product_size.update(edit_params)
        format.html { redirect_to adm_redeem_redeem_product_size_path(@adm_redeem_redeem_product_size), notice: 'Redeem product size was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @adm_redeem_redeem_product_size.destroy
    respond_to do |format|
      format.html { redirect_to adm_redeem_redeem_product_sizes_url, notice: 'Redeem product size was successfully destroyed.' }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_adm_redeem_redeem_product_size
    @adm_redeem_redeem_product_size = Redeem::RedeemProductSize.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def adm_redeem_redeem_product_size_params
    params.fetch(:adm_redeem_redeem_product_size, {})
  end

  def create_params
    params.permit(:name)
  end

  def edit_params
    params.permit(:name)
  end
end
