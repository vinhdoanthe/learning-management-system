module User
  class OpTeachersController < ApplicationController

    before_action :authenticate_faculty!, :teacher_info

    def teacher_info

    end
  end

end