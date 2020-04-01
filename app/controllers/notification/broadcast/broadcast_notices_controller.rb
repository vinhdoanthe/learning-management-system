class Notification::Broadcast::BroadcastNoticesController < ApplicationController
  before_action :find_notice, only: [:show]
  
  def index
    @notices = Notification::BroadcastNoti.where('expiry_date >= ?', Time.now).all
  end

  def show
  end

  private

  def find_notice
    @notice = Notification::BroadcastNoti.where(id: params[:id]).first
  end
end
