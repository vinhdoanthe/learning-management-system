class Notification::User::UserNotificationsController < ActivityNotification::NotificationsController
  include NotificationConstants::Type

  skip_before_action :set_notification, :only => [:move]

  def index
    super
    @notifications = @target.notifications.order_by(created_at: :DESC).page(params[:page]).per(20)
  end

  def move
    @notification = ActivityNotification::Notification.with_target.find(params[:id])
    notifiable = @notification.notifiable
    unless notifiable.nil?
      super
    else
      notifiable_type = @notification.notifiable_type
      if notifiable_type == SC_PT_POST or notifiable_type == SC_RW_POST or notifiable_type == SC_ST_PROJECT_POST or notifiable_type == SC_REDEEM_POST
        redirect_to social_community_feed_post_path(@notification.notifiable_id) 
      elsif notifiable_type == SC_QA_THREAD
        redirect_to social_community_question_answer_thread_path(@notification.notifiable_id)
      end
    end
  end

  private

  def set_target
    if (target_type = params[:target_type]).present?
      target_class = if target_type == 'users'
                       User::Account::User
                     else
                       target_type.to_model_class
                     end

      @target = params[:target_id].present? ?

        target_class.find_by!(id: params[:target_id]) :
        target_class.find_by!(id: params["#{target_type.to_resource_name}_id"])
    else
      render status: 400, json: error_response(code: 400, message: "Invalid parameter", type: "Parameter is missing or the value is empty: target_type")
    end
  end
end
