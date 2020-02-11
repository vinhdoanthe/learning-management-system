module User
  class UsersController < ApplicationController

    before_action :authenticate_student!, :my_class

    def information

    end

    def my_class
      @batches = current_user.op_student.op_batches
    end

    # TODO: return general information of a student
    def general_information

      render :json => {}
    end


    # TODO: return parent information of a student
    def parent_information

      render :json => {}
    end
  end
end
