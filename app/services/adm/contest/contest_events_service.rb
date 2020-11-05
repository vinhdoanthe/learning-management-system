class Adm::Contest::ContestEventsService
  def update_event event, params
    atts = ['name', 'link', 'thumbnail']

    atts.each do |att|
      event.send(att + '=', params[att]) if params[att].present?
    end

    if event.save
      { type: 'success', message: 'Cập nhật thành công!' }
    else
      { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau!' }
    end
  end
end
