class Redeem::RedeemProductItemService

  # params
  # :product_id
  # :color_id
  # :size_id
  # :amount
  def create_items params
    item_ids = []
    validate_params params
    amount = params[:amount].to_i
    product = Redeem::RedeemProduct.where(id: params[:product_id]).first
    item_code_prefix = product&.code.to_s
    item = Redeem::RedeemProductItem.where(:product_id => params[:product_id]).order(:created_at => :DESC).first
    last_item_code = item&.item_code.to_s
    item_code_index = last_item_code[/\d+(?=\D*\z)/].to_i
    Redeem::RedeemProductItem.transaction do
      begin
        amount.times do
          item_code_index += 1
          item = Redeem::RedeemProductItem.new(
            :product_id => params[:product_id],
            :size_id => params[:size_id],
            :color_id => params[:color_id],
            :item_code => "#{item_code_prefix}_#{item_code_index}",
            :state => RedeemConstants::ProductItem::STATE_AVAILABLE,
            :input_date => Time.now
          )
          item.save
          item_ids << item.id
        end
      rescue Exception => e
        puts e.inspect
      end
      item_ids
    end
  end

  private
  def validate_params params
    # TODO: validate product_id, color_id, size_id and amount
  end

end
