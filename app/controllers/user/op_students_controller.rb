module User

  class OpStudentsController < ApplicationController

    before_action :authenticate_student!, :student_info
    def index
      @op_students = OpStudent.all
    end

    def new

    end

    def student_info

    end

    def student_homework

    end

    def student_product

    end

    def student_redeem

    end

    def student_invoice

    end
  end

end
