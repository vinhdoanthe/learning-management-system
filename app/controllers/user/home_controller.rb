module User
  class HomeController < ApplicationController
    def dashboard
      # TODO : Redirect URL based on User role
      redirect_to user_my_class_path
    end
  end
end
