class Notification::User::UserNotificationsController < ActivityNotification::NotificationsController
  def index
    binding.pry
    @notifications = @target.notifications
  end

  def open
    binding.pry
  end

end
