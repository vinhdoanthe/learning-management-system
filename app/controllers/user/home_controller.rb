module User
  class HomeController < ApplicationController
    def dashboard
      if current_user.nil?
        redirect_to user_login_path
      else
        if current_user.is_student?
          redirect_to user_my_class_path
        else
          redirect_to user_parent_selection_path
        end
      end
      # TODO : Redirect URL based on User role
    end
  end
end
