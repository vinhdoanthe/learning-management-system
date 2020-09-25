class Adm::Redeem::RedeemProductsController < ApplicationController
  before_action :set_adm_redeem_redeem_product, only: [:show, :edit, :update, :destroy]

  def index
    @adm_redeem_redeem_products = Redeem::RedeemProduct.order(:created_at => :ASC).all

    # caculate warehouse state of each product
    @product_available_counts = Redeem::RedeemProductItem.where(state:RedeemConstants::ProductItem::STATE_AVAILABLE).group(:product_id).count
    @product_locked_counts = Redeem::RedeemProductItem.where(state:RedeemConstants::ProductItem::STATE_LOCKED).group(:product_id).count
    @product_sold_counts = Redeem::RedeemProductItem.where(state:RedeemConstants::ProductItem::STATE_SOLD).group(:product_id).count
  end

  def show

    # report product by states
    @states = Redeem::RedeemProductItem.where(product_id: @adm_redeem_redeem_product.id).group(:state).count

  end

  def new
    @adm_redeem_redeem_product = Redeem::RedeemProduct.new
  end

  def edit
  end

  def create
    @adm_redeem_redeem_product = Redeem::RedeemProduct.new(create_params)

    respond_to do |format|
      if @adm_redeem_redeem_product.save
        format.html { redirect_to adm_redeem_redeem_product_path(@adm_redeem_redeem_product), notice: 'Redeem product was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @adm_redeem_redeem_product.update(edit_params)
        format.html { redirect_to adm_redeem_redeem_product_path(@adm_redeem_redeem_product), notice: 'Redeem product was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @adm_redeem_redeem_product.destroy
    respond_to do |format|
      format.html { redirect_to adm_redeem_redeem_products_url, notice: 'Redeem product was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_adm_redeem_redeem_product
      @adm_redeem_redeem_product = Redeem::RedeemProduct.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def adm_redeem_redeem_product_params
      params.fetch(:adm_redeem_redeem_product, {})
    end

    def create_params
      params.permit(:name, :code, :price, :description, :category_id, :brand_id, :images => [])
    end

    def edit_params
      params.permit(:name, :code, :price, :description, :category_id, :brand_id, :images => [])
    end
end
