module User
  class HomeController < ApplicationController
    def dashboard
      # TODO : Redirect URL based on User role
      if current_user.is_student?
        redirect_to user_my_class_path
      elsif current_user.is_parent?
        redirect_to user_parent_selection_path
      elsif current_user.is_teacher?

      elsif current_user.is_admin?
        redirect_to rails_admin_path
      end
    end
  end
end
