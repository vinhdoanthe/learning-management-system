module User
  module UsersHelper

    def stage_active?(batch_id)
      op_student_course = Learning::Batch::OpStudentCourse.where(student_id: current_user.op_student.id, batch_id: batch_id).first
      if op_student_course.state == Learning::Constant::STUDENT_BATCH_STATUS_ON
        true
      else
        false
      end
    end
  end
end
