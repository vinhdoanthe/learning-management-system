class Adm::Redeem::RedeemProductBrandsController < Adm::AdmController
  before_action :set_adm_redeem_redeem_product_brand, only: [:show, :edit, :update, :destroy]

  def index
    @adm_redeem_redeem_product_brands = Redeem::RedeemProductBrand.order(:created_at => :ASC).all
  end

  def show
  end

  def new
    @adm_redeem_redeem_product_brand = Redeem::RedeemProductBrand.new
  end

  def edit
  end

  def create
    # binding.pry
    @adm_redeem_redeem_product_brand = Redeem::RedeemProductBrand.new(create_params)

    respond_to do |format|
      if @adm_redeem_redeem_product_brand.save
        format.html { redirect_to adm_redeem_redeem_product_brand_path(@adm_redeem_redeem_product_brand), notice: 'Redeem product brand was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @adm_redeem_redeem_product_brand.update(edit_params)
        format.html { redirect_to adm_redeem_redeem_product_brand_path(@adm_redeem_redeem_product_brand), notice: 'Redeem product brand was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @adm_redeem_redeem_product_brand.destroy
    respond_to do |format|
      format.html { redirect_to adm_redeem_redeem_product_brands_url, notice: 'Redeem product brand was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_adm_redeem_redeem_product_brand
      @adm_redeem_redeem_product_brand = Redeem::RedeemProductBrand.find(params[:id])
    end

    def adm_redeem_redeem_product_brand_params
      params.fetch(:redeem_redeem_product_brand, {})
    end

    def create_params
      params.permit(:name)
    end
    
    def edit_params
      params.permit(:name)
    end
end
