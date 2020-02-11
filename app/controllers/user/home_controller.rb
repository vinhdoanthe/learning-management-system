module User
  class HomeController < ApplicationController
    def dashboard
      # TODO : Redirect URL based on User role
      if current_user.is_student?
        redirect_to user_my_class_path
      else
        redirect_to user_parent_selection_path
      end
    end
  end
end
