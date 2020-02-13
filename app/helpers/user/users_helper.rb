module User
  module UsersHelper

    def get_stage(op_student_id, op_batch_id)
      op_student_course = Learning::Batch::OpStudentCourse.where(student_id: op_student_id, batch_id: op_batch_id).first
      op_student_course.state
    end
  end
end
