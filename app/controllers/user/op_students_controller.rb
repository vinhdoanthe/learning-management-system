module User

  class OpStudentsController < ApplicationController

    def index
      @op_students = OpStudent.all
    end

    def new

    end

    def student_info

    end
  end

end
