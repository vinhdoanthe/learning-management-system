class Adm::Redeem::RedeemProductBrandsController < ApplicationController
  before_action :set_adm_redeem_redeem_product_brand, only: [:show, :edit, :update, :destroy]

  # GET /redeem/redeem_product_brands
  # GET /redeem/redeem_product_brands.json
  def index
    @adm_redeem_redeem_product_brands = Redeem::RedeemProductBrand.all
  end

  # GET /redeem/redeem_product_brands/1
  # GET /redeem/redeem_product_brands/1.json
  def show
  end

  # GET /redeem/redeem_product_brands/new
  def new
    @adm_redeem_redeem_product_brand = Redeem::RedeemProductBrand.new
  end

  # GET /redeem/redeem_product_brands/1/edit
  def edit
  end

  # POST /redeem/redeem_product_brands
  # POST /redeem/redeem_product_brands.json
  def create
    @adm_redeem_redeem_product_brand = Redeem::RedeemProductBrand.new(adm_redeem_redeem_product_brand_params)

    respond_to do |format|
      if @adm_redeem_redeem_product_brand.save
        format.html { redirect_to @adm_redeem_redeem_product_brand, notice: 'Redeem product brand was successfully created.' }
        format.json { render :show, status: :created, location: @adm_redeem_redeem_product_brand }
      else
        format.html { render :new }
        format.json { render json: @adm_redeem_redeem_product_brand.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /redeem/redeem_product_brands/1
  # PATCH/PUT /redeem/redeem_product_brands/1.json
  def update
    respond_to do |format|
      if @adm_redeem_redeem_product_brand.update(adm_redeem_redeem_product_brand_params)
        format.html { redirect_to @adm_redeem_redeem_product_brand, notice: 'Redeem product brand was successfully updated.' }
        format.json { render :show, status: :ok, location: @adm_redeem_redeem_product_brand }
      else
        format.html { render :edit }
        format.json { render json: @adm_redeem_redeem_product_brand.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /redeem/redeem_product_brands/1
  # DELETE /redeem/redeem_product_brands/1.json
  def destroy
    @adm_redeem_redeem_product_brand.destroy
    respond_to do |format|
      format.html { redirect_to adm_redeem_redeem_product_brands_url, notice: 'Redeem product brand was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_adm_redeem_redeem_product_brand
      @adm_redeem_redeem_product_brand = Redeem::RedeemProductBrand.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def adm_redeem_redeem_product_brand_params
      params.fetch(:adm_redeem_redeem_product_brand, {})
    end
end
