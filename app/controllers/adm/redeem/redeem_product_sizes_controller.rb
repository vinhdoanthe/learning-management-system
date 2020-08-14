class Adm::Redeem::RedeemProductSizesController < ApplicationController
  before_action :set_adm_redeem_redeem_product_size, only: [:show, :edit, :update, :destroy]

  # GET /redeem/redeem_product_sizes
  # GET /redeem/redeem_product_sizes.json
  def index
    @adm_redeem_redeem_product_sizes = Redeem::RedeemProductSize.all
  end

  # GET /redeem/redeem_product_sizes/1
  # GET /redeem/redeem_product_sizes/1.json
  def show
  end

  # GET /redeem/redeem_product_sizes/new
  def new
    @adm_redeem_redeem_product_size = Redeem::RedeemProductSize.new
  end

  # GET /redeem/redeem_product_sizes/1/edit
  def edit
  end

  # POST /redeem/redeem_product_sizes
  # POST /redeem/redeem_product_sizes.json
  def create
    @adm_redeem_redeem_product_size = Redeem::RedeemProductSize.new(adm_redeem_redeem_product_size_params)

    respond_to do |format|
      if @adm_redeem_redeem_product_size.save
        format.html { redirect_to @adm_redeem_redeem_product_size, notice: 'Redeem product size was successfully created.' }
        format.json { render :show, status: :created, location: @adm_redeem_redeem_product_size }
      else
        format.html { render :new }
        format.json { render json: @adm_redeem_redeem_product_size.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /redeem/redeem_product_sizes/1
  # PATCH/PUT /redeem/redeem_product_sizes/1.json
  def update
    respond_to do |format|
      if @adm_redeem_redeem_product_size.update(adm_redeem_redeem_product_size_params)
        format.html { redirect_to @adm_redeem_redeem_product_size, notice: 'Redeem product size was successfully updated.' }
        format.json { render :show, status: :ok, location: @adm_redeem_redeem_product_size }
      else
        format.html { render :edit }
        format.json { render json: @adm_redeem_redeem_product_size.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /redeem/redeem_product_sizes/1
  # DELETE /redeem/redeem_product_sizes/1.json
  def destroy
    @adm_redeem_redeem_product_size.destroy
    respond_to do |format|
      format.html { redirect_to adm_redeem_redeem_product_sizes_url, notice: 'Redeem product size was successfully destroyed.' }
      format.json { head :no_content }
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
end
