class User::HomeController < ApplicationController
  include User::SessionsHelper
  def dashboard
    if current_user.nil?
      redirect_to user_login_path
    else
      if current_user.is_student?
        redirect_to social_community_student_dashboard_path
      elsif current_user.is_parent?
        redirect_to user_parent_selection_path
      elsif current_user.is_teacher?
        redirect_to social_community_teacher_dashboard_path
      elsif current_user.is_admin?
        redirect_to rails_admin_path
      end
    end
  end
end
