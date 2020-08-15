module Redeem::RedeemsHelper
  def get_available_size_and_color product
    product_items = product.redeem_product_items
    available_color_ids = product_items.pluck(:color_id).uniq
    available_size_ids = product_items.pluck(:size_id).uniq

    available_sizes = Redeem::RedeemProductSize.where(id: available_size_ids)
    available_colors = Redeem::RedeemProductColor.where(id: available_color_ids)

    { size: available_sizes, color: available_colors }
  end
end
