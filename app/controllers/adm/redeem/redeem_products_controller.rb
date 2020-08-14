class Adm::Redeem::RedeemProductsController < ApplicationController
  before_action :set_adm_redeem_redeem_product, only: [:show, :edit, :update, :destroy]

  # GET /redeem/redeem_products
  # GET /redeem/redeem_products.json
  def index
    @adm_redeem_redeem_products = Redeem::RedeemProduct.all
  end

  # GET /redeem/redeem_products/1
  # GET /redeem/redeem_products/1.json
  def show
  end

  # GET /redeem/redeem_products/new
  def new
    @adm_redeem_redeem_product = Redeem::RedeemProduct.new
  end

  # GET /redeem/redeem_products/1/edit
  def edit
  end

  # POST /redeem/redeem_products
  # POST /redeem/redeem_products.json
  def create
    @adm_redeem_redeem_product = Redeem::RedeemProduct.new(adm_redeem_redeem_product_params)

    respond_to do |format|
      if @adm_redeem_redeem_product.save
        format.html { redirect_to @adm_redeem_redeem_product, notice: 'Redeem product was successfully created.' }
        format.json { render :show, status: :created, location: @adm_redeem_redeem_product }
      else
        format.html { render :new }
        format.json { render json: @adm_redeem_redeem_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /redeem/redeem_products/1
  # PATCH/PUT /redeem/redeem_products/1.json
  def update
    respond_to do |format|
      if @adm_redeem_redeem_product.update(adm_redeem_redeem_product_params)
        format.html { redirect_to @adm_redeem_redeem_product, notice: 'Redeem product was successfully updated.' }
        format.json { render :show, status: :ok, location: @adm_redeem_redeem_product }
      else
        format.html { render :edit }
        format.json { render json: @adm_redeem_redeem_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /redeem/redeem_products/1
  # DELETE /redeem/redeem_products/1.json
  def destroy
    @adm_redeem_redeem_product.destroy
    respond_to do |format|
      format.html { redirect_to adm_redeem_redeem_products_url, notice: 'Redeem product was successfully destroyed.' }
      format.json { head :no_content }
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
end
