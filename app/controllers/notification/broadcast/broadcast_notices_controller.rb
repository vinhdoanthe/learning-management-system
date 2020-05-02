class Notification::Broadcast::BroadcastNoticesController < ApplicationController
  before_action :find_notice, only: [:show]
  
  def index
    @notices = Notification::BroadcastNoti.order(created_at: :DESC).all
  end

  def show
  end
  
  def read_notice
    Notification::BroadcastNoti::BroadcastService.new.read_notice current_user.id, params[:notice_id]  
  end

  private

  def find_notice
    @notice = Notification::BroadcastNoti.where(id: params[:id]).first
  end
end
