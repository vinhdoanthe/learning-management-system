class Adm::Redeem::RedeemProductColorsController < ApplicationController
  before_action :set_adm_redeem_redeem_product_color, only: [:show, :edit, :update, :destroy]

  def index
    @adm_redeem_redeem_product_colors = Redeem::RedeemProductColor.order(:created_at => :ASC).all
  end

  def show
  end

  def new
    @adm_redeem_redeem_product_color = Redeem::RedeemProductColor.new
  end

  def edit
  end

  def create
    @adm_redeem_redeem_product_color = Redeem::RedeemProductColor.new(create_params)

    respond_to do |format|
      if @adm_redeem_redeem_product_color.save
        format.html { redirect_to adm_redeem_redeem_product_color_path(@adm_redeem_redeem_product_color), notice: 'Redeem product color was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @adm_redeem_redeem_product_color.update(edit_params)
        format.html { redirect_to adm_redeem_redeem_product_color_path(@adm_redeem_redeem_product_color), notice: 'Redeem product color was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @adm_redeem_redeem_product_color.destroy
    respond_to do |format|
      format.html { redirect_to adm_redeem_redeem_product_colors_url, notice: 'Redeem product color was successfully destroyed.' }
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
    
    def create_params
      params.permit(:name, :color_code)
    end

    def edit_params
      params.permit(:name, :color_code)
    end
end
