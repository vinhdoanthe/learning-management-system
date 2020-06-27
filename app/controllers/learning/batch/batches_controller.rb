class Learning::Batch::OpBatchesController
 
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
        render '', :locals => {:data => data}
      }
    end
  end

  private
  def student_homework_report_params
    [params[:batch_id], params[:subject_id], params[:faculty_id]]
  end
end
