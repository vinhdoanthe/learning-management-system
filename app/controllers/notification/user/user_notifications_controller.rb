class Notification::User::UserNotificationsController < ActivityNotification::NotificationsController

  def index
    super
    @notifications = @target.notifications.order_by(created_at: :DESC).page(params[:page]).per(20)
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
