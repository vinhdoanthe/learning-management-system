class Adm::Redeem::RedeemProductItemsController < ApplicationController
  before_action :set_adm_redeem_redeem_product_item, only: [:show, :edit, :update, :destroy]

  def index
    @products = Redeem::RedeemProduct.all
    @product_item_states = Redeem::RedeemProductItem.pluck(:state).uniq
    @adm_redeem_redeem_products_items = Adm::Redeem::RedeemProductsService.new.filter_product_items params
  end

  def show
  end

  def new
    @adm_redeem_redeem_product_item = Redeem::RedeemProductItem.new
  end

  def edit
  end

  def create
    product_item_service = Redeem::RedeemProductItemService.new
    permited_params = create_params
    item_ids = product_item_service.create_items(permited_params)

    # @adm_redeem_redeem_product_item = Redeem::RedeemProductItem.new(adm_redeem_redeem_product_item_params)

    respond_to do |format|
      # if @adm_redeem_redeem_product_item.save
      if !item_ids.blank?
        flash[:success] = 'Redeem product item was successfully created.'
        format.html { redirect_to adm_redeem_redeem_product_items_path }
      else
        flash[:danger] = 'Error!!!'
        format.html { render :new }
      end
    end
  end

  # def update
  #   respond_to do |format|
  #     if @adm_redeem_redeem_product_item.update(adm_redeem_redeem_product_item_params)
  #       format.html { redirect_to @adm_redeem_redeem_product_item, notice: 'Redeem product item was successfully updated.' }
  #     else
  #       format.html { render :edit }
  #     end
  #   end
  # end

  def destroy
    @adm_redeem_redeem_product_item.destroy
    respond_to do |format|
      flash[:success] = 'Redeem product item was successfully destroyed.'
      format.html { redirect_to adm_redeem_redeem_product_items_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_adm_redeem_redeem_product_item
      @adm_redeem_redeem_product_item = Redeem::RedeemProductItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def adm_redeem_redeem_product_item_params
      params.fetch(:adm_redeem_redeem_product_item, {})
    end

    def create_params
      params.permit(:product_id, :size_id, :color_id, :amount)
    end
end
