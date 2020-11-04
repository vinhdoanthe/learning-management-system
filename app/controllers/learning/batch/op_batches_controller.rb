class Learning::Batch::OpBatchesController < ApplicationController

  # get report homework of all students in a batch
  # params
  # batch_id
  # faculty_id 
  def student_homework_report
    batch_id, subject_id, faculty_id = student_homework_report_params
    data = Learning::Batch::OpBatchService.get_student_homework_report(batch_id, subject_id, faculty_id)
    respond_to do |format|
      format.html
      format.json
      format.js {
        render 'user/open_educat/op_teachers/js/teacher_class_details/student_homework_report', :locals => {:data => data}
      }
    end
  end

  def student_batch_subjects
    batch = Learning::Batch::OpBatch.where(id: params[:batch_id]).first
    student_course = Learning::Batch::OpStudentCourse.where(batch_id: batch.id, student_id: current_user.op_student.id).first
    subjects = student_course.op_subjects.pluck(:id, :level).uniq

    render json: subjects
  end

  private
  def student_homework_report_params
    [params[:batch_id], params[:subject_id], params[:faculty_id]]
  end
end
