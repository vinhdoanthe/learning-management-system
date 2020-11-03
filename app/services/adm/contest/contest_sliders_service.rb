class Adm::Contest::ContestSlidersService

  def update_slider params
    if params[:id].present?
      slider = Contest::ContestSlider.where(id: params[:id]).first
      update slider, params
    else
      create params
    end
  end

  def update slider, params
    atts = ['logo', 'image', 'thumbnail', 'title', 'image_side', 'is_publish']

    atts.each do |att|
      slider.send(att + '=', params[att]) if params[att].present?
    end

    if slider.save
      { type: 'success', message: 'Cập nhật thành công!' }
    else
      { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau!' }
    end
  end

  def create params
    slider = Contest::ContestSlider.new

    if can_create? params
      update slider, params
    else
      return { type: 'danger', message: 'Không thể tạo slide! Vui lòng kiểm tra lại thông tin!'}
    end
  end

  private

  def can_create? params
    result = true
    atts = ['logo', 'thumbnail', 'image_side']
    atts.each{ |att| result = false if params[att].blank? }

    result
  end
end
