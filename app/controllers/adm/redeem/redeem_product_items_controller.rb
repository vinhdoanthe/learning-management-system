class Adm::Redeem::RedeemProductItemsController < ApplicationController
  before_action :set_adm_redeem_redeem_product_item, only: [:show, :edit, :update, :destroy]

  # GET /redeem/redeem_product_items
  # GET /redeem/redeem_product_items.json
  def index
    @adm_redeem_redeem_product_items = Redeem::RedeemProductItem.all
  end

  # GET /redeem/redeem_product_items/1
  # GET /redeem/redeem_product_items/1.json
  def show
  end

  # GET /redeem/redeem_product_items/new
  def new
    @adm_redeem_redeem_product_item = Redeem::RedeemProductItem.new
  end

  # GET /redeem/redeem_product_items/1/edit
  def edit
  end

  # POST /redeem/redeem_product_items
  # POST /redeem/redeem_product_items.json
  def create
    @adm_redeem_redeem_product_item = Redeem::RedeemProductItem.new(adm_redeem_redeem_product_item_params)

    respond_to do |format|
      if @adm_redeem_redeem_product_item.save
        format.html { redirect_to @adm_redeem_redeem_product_item, notice: 'Redeem product item was successfully created.' }
        format.json { render :show, status: :created, location: @adm_redeem_redeem_product_item }
      else
        format.html { render :new }
        format.json { render json: @adm_redeem_redeem_product_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /redeem/redeem_product_items/1
  # PATCH/PUT /redeem/redeem_product_items/1.json
  def update
    respond_to do |format|
      if @adm_redeem_redeem_product_item.update(adm_redeem_redeem_product_item_params)
        format.html { redirect_to @adm_redeem_redeem_product_item, notice: 'Redeem product item was successfully updated.' }
        format.json { render :show, status: :ok, location: @adm_redeem_redeem_product_item }
      else
        format.html { render :edit }
        format.json { render json: @adm_redeem_redeem_product_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /redeem/redeem_product_items/1
  # DELETE /redeem/redeem_product_items/1.json
  def destroy
    @adm_redeem_redeem_product_item.destroy
    respond_to do |format|
      format.html { redirect_to adm_redeem_redeem_product_items_url, notice: 'Redeem product item was successfully destroyed.' }
      format.json { head :no_content }
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
end
