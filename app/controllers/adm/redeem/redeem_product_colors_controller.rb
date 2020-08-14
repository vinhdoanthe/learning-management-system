class Adm::Redeem::RedeemProductColorsController < ApplicationController
  before_action :set_adm_redeem_redeem_product_color, only: [:show, :edit, :update, :destroy]

  # GET /redeem/redeem_product_colors
  # GET /redeem/redeem_product_colors.json
  def index
    @adm_redeem_redeem_product_colors = Redeem::RedeemProductColor.all
  end

  # GET /redeem/redeem_product_colors/1
  # GET /redeem/redeem_product_colors/1.json
  def show
  end

  # GET /redeem/redeem_product_colors/new
  def new
    @adm_redeem_redeem_product_color = Redeem::RedeemProductColor.new
  end

  # GET /redeem/redeem_product_colors/1/edit
  def edit
  end

  # POST /redeem/redeem_product_colors
  # POST /redeem/redeem_product_colors.json
  def create
    @adm_redeem_redeem_product_color = Redeem::RedeemProductColor.new(adm_redeem_redeem_product_color_params)

    respond_to do |format|
      if @adm_redeem_redeem_product_color.save
        format.html { redirect_to @adm_redeem_redeem_product_color, notice: 'Redeem product color was successfully created.' }
        format.json { render :show, status: :created, location: @adm_redeem_redeem_product_color }
      else
        format.html { render :new }
        format.json { render json: @adm_redeem_redeem_product_color.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /redeem/redeem_product_colors/1
  # PATCH/PUT /redeem/redeem_product_colors/1.json
  def update
    respond_to do |format|
      if @adm_redeem_redeem_product_color.update(adm_redeem_redeem_product_color_params)
        format.html { redirect_to @adm_redeem_redeem_product_color, notice: 'Redeem product color was successfully updated.' }
        format.json { render :show, status: :ok, location: @adm_redeem_redeem_product_color }
      else
        format.html { render :edit }
        format.json { render json: @adm_redeem_redeem_product_color.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /redeem/redeem_product_colors/1
  # DELETE /redeem/redeem_product_colors/1.json
  def destroy
    @adm_redeem_redeem_product_color.destroy
    respond_to do |format|
      format.html { redirect_to adm_redeem_redeem_product_colors_url, notice: 'Redeem product color was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_adm_redeem_redeem_product_color
      @adm_redeem_redeem_product_color = Redeem::RedeemProductColor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def adm_redeem_redeem_product_color_params
      params.fetch(:adm_redeem_redeem_product_color, {})
    end
end
