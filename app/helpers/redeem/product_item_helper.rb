module Redeem::ProductItemHelper
  def get_state_css_class item
    if item.available?
      class_name = 'info'
    elsif item.locked?
      class_name = 'warning'
    elsif item.sold?
      class_name = 'secondary'
    end 

    class_name
  end
end
