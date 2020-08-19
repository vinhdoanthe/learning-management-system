class Adm::Redeem::RedeemProductCategoriesController < Adm::AdmController
  before_action :set_adm_redeem_redeem_product_category, only: [:show, :edit, :update, :destroy]

  def index
    @adm_redeem_redeem_product_categories = Redeem::RedeemProductCategory.order(:created_at => :ASC).all
  end

  def show
  end

  def new
    @adm_redeem_redeem_product_category = Redeem::RedeemProductCategory.new
  end

  def edit
  end

  def create
    @adm_redeem_redeem_product_category = Redeem::RedeemProductCategory.new(create_params)

    respond_to do |format|
      if @adm_redeem_redeem_product_category.save
        format.html { redirect_to adm_redeem_redeem_product_category_path(@adm_redeem_redeem_product_category), notice: 'Redeem product category was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @adm_redeem_redeem_product_category.update(edit_params)
        format.html { redirect_to adm_redeem_redeem_product_category_path(@adm_redeem_redeem_product_category), notice: 'Redeem product category was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @adm_redeem_redeem_product_category.destroy
    respond_to do |format|
      format.html { redirect_to adm_redeem_redeem_product_categories_url, notice: 'Redeem product category was successfully destroyed.' }
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

    def create_params
      params.permit(:name)
    end
    
    def edit_params
      params.permit(:name)
    end
end
