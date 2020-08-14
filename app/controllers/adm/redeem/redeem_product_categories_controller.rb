class Adm::Redeem::RedeemProductCategoriesController < ApplicationController
  before_action :set_adm_redeem_redeem_product_category, only: [:show, :edit, :update, :destroy]

  # GET /redeem/redeem_product_categories
  # GET /redeem/redeem_product_categories.json
  def index
    @adm_redeem_redeem_product_categories = Redeem::RedeemProductCategory.all
  end

  # GET /redeem/redeem_product_categories/1
  # GET /redeem/redeem_product_categories/1.json
  def show
  end

  # GET /redeem/redeem_product_categories/new
  def new
    @adm_redeem_redeem_product_category = Redeem::RedeemProductCategory.new
  end

  # GET /redeem/redeem_product_categories/1/edit
  def edit
  end

  # POST /redeem/redeem_product_categories
  # POST /redeem/redeem_product_categories.json
  def create
    @adm_redeem_redeem_product_category = Redeem::RedeemProductCategory.new(adm_redeem_redeem_product_category_params)

    respond_to do |format|
      if @adm_redeem_redeem_product_category.save
        format.html { redirect_to @adm_redeem_redeem_product_category, notice: 'Redeem product category was successfully created.' }
        format.json { render :show, status: :created, location: @adm_redeem_redeem_product_category }
      else
        format.html { render :new }
        format.json { render json: @adm_redeem_redeem_product_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /redeem/redeem_product_categories/1
  # PATCH/PUT /redeem/redeem_product_categories/1.json
  def update
    respond_to do |format|
      if @adm_redeem_redeem_product_category.update(adm_redeem_redeem_product_category_params)
        format.html { redirect_to @adm_redeem_redeem_product_category, notice: 'Redeem product category was successfully updated.' }
        format.json { render :show, status: :ok, location: @adm_redeem_redeem_product_category }
      else
        format.html { render :edit }
        format.json { render json: @adm_redeem_redeem_product_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /redeem/redeem_product_categories/1
  # DELETE /redeem/redeem_product_categories/1.json
  def destroy
    @adm_redeem_redeem_product_category.destroy
    respond_to do |format|
      format.html { redirect_to adm_redeem_redeem_product_categories_url, notice: 'Redeem product category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_adm_redeem_redeem_product_category
      @adm_redeem_redeem_product_category = Redeem::RedeemProductCategory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def adm_redeem_redeem_product_category_params
      params.fetch(:adm_redeem_redeem_product_category, {})
    end
end
