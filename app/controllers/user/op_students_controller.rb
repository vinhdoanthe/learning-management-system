module User

  class OpStudentsController < ApplicationController

    def index
      @op_students = OpStudent.all
    end

    def new

    end
  end

end
