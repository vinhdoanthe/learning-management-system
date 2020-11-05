class Adm::Contest::ContestEventsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update_event]

  def index
    @events = Contest::ContestEvent.where(created_at: (Time.now - 6.months)..Time.now)
  end

  def event_detail
    if params[:id].present?
      @event = Contest::ContestEvent.where(id: params[:id]).first
    else
      @event = Contest::ContestEvent.new
    end
  end

  def update_event
    if params[:id].present?
      event = Contest::ContestEvent.where(id: params[:id]).first
    else
      event = Contest::ContestEvent.new
    end

    result = Adm::Contest::ContestEventsService.new.update_event event, params

    render json: result
  end

  def delete_event
    event = Contest::ContestEvent.where(id: params[:id]).first

    if event.present?
      if event.delete
        result = { type: 'success', message: 'Xoá thành công' }
      else 
        result = { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau!' }
      end
    else
      result = { type: 'danger', message: 'Event không tồn tại hoặc đã bị xoá!' }
    end

    render json: result
  end
end
