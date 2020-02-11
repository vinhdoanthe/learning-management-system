module User
  module UsersHelper

    def get_stage(batch_id)
      op_student_course = Learning::Batch::OpStudentCourse.where(student_id: current_user.op_student.id, batch_id: batch_id).first
      op_student_course.state
    end
  end
end
